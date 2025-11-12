#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to automatically add images from news posts to the team gallery
# Usage: ruby scripts/news_to_gallery.rb [gallery_page] [--delete-originals]
# Default: pages/team-gallery.md
# Options:
#   --delete-originals: Delete original image files after copying to gallery (default: false)

require 'yaml'
require 'date'
require 'fileutils'
require 'set'

# Parse command line arguments
delete_originals = ARGV.include?('--delete-originals')
gallery_file = ARGV.find { |arg| !arg.start_with?('--') } || 'pages/team-gallery.md'
posts_dir = '_posts'
gallery_dir = 'assets/img/gallery'

# Track images that were copied and need path updates
copied_images = {} # { original_path => gallery_path }

unless File.exist?(gallery_file)
  puts "Error: Gallery file not found: #{gallery_file}"
  exit 1
end

unless Dir.exist?(posts_dir)
  puts "Error: Posts directory not found: #{posts_dir}"
  exit 1
end

# Read existing gallery
gallery_content = File.read(gallery_file, encoding: 'UTF-8')
front_matter_match = gallery_content.match(/\A---\n(.*?)\n---\n(.*)\z/m)
unless front_matter_match
  puts "Error: Could not parse gallery file front matter"
  exit 1
end

front_matter = YAML.safe_load(front_matter_match[1])
existing_gallery = front_matter['gallery'] || []
existing_images = existing_gallery.map { |item| item['image_url'] }.compact.to_set

puts "Found #{existing_images.size} existing gallery images"

# Scan posts for images
new_gallery_items = []
posts_processed = 0
posts_with_images = 0

Dir.glob(File.join(posts_dir, '*.md')).each do |post_file|
  posts_processed += 1
  post_content = File.read(post_file, encoding: 'UTF-8')
  
  # Parse front matter
  post_front_matter_match = post_content.match(/\A---\n(.*?)\n---\n(.*)\z/m)
  next unless post_front_matter_match
  
  post_front_matter = YAML.safe_load(post_front_matter_match[1])
  post_body = post_front_matter_match[2]
  
  post_title = post_front_matter['title'] || ''
  post_date = post_front_matter['date'] || File.basename(post_file)[0..9]
  post_year = post_date[0..3] if post_date
  
  # Extract images from front matter
  images_found = []
  
  if post_front_matter['image']
    image_config = post_front_matter['image']
    ['homepage', 'thumb', 'header', 'title'].each do |key|
      if image_config[key] && !image_config[key].empty?
        images_found << {
          filename: File.basename(image_config[key]),
          source: "front_matter.#{key}",
          post_title: post_title,
          post_date: post_date,
          post_year: post_year
        }
      end
    end
  end
  
  # Extract images from markdown content: ![alt](url)
  post_body.scan(/!\[([^\]]*)\]\(([^)]+)\)/) do |alt_text, url|
    # Extract filename from URL (could be relative or absolute)
    filename = File.basename(url.split('?').first) # Remove query params
    # Skip if it's a data URI or external URL without a clear filename
    next if filename.empty? || filename == url || url.start_with?('http://', 'https://', 'data:')
    
    images_found << {
      filename: filename,
      source: 'markdown',
      alt_text: alt_text,
      post_title: post_title,
      post_date: post_date,
      post_year: post_year
    }
  end
  
  # Extract images from HTML: <img src="...">
  post_body.scan(/<img[^>]+src=["']([^"']+)["'][^>]*>/) do |url|
    filename = File.basename(url.split('?').first)
    next if filename.empty? || filename == url || url.start_with?('http://', 'https://', 'data:')
    
    images_found << {
      filename: filename,
      source: 'html',
      post_title: post_title,
      post_date: post_date,
      post_year: post_year
    }
  end
  
  # Process found images
  images_found.each do |img_info|
    filename = img_info[:filename]
    
    # Generate date-prefixed filename for gallery (YYYY-MM-DD-originalname.ext)
    # This ensures chronological sorting by filename
    date_prefix = post_date || '0000-01-01'
    # Remove any existing date prefix from filename to avoid duplicates
    base_filename = filename.sub(/^\d{4}-\d{2}-\d{2}-/, '')
    dated_filename = "#{date_prefix}-#{base_filename}"
    
    # Check if already in gallery (check both original and dated filename)
    if existing_images.include?(dated_filename)
      # Already in gallery with date prefix, skip
      next
    elsif existing_images.include?(filename)
      # Exists without date prefix in gallery front matter - check if file needs renaming
      original_gallery_path = File.join(gallery_dir, filename)
      gallery_image_path = File.join(gallery_dir, dated_filename)
      
      if File.exist?(gallery_image_path)
        # File is already renamed to dated version, but gallery front matter still has old name
        # Update the gallery entry to match the existing file
        puts "  File already renamed to #{dated_filename}, updating gallery entry..."
        existing_images.delete(filename)
        existing_images.add(dated_filename)
        existing_gallery.each do |item|
          if item['image_url'] == filename
            item['image_url'] = dated_filename
            puts "  Updated gallery entry: #{filename} → #{dated_filename}"
          end
        end
        # Track this for markdown path updates
        old_gallery_url = "/assets/img/gallery/#{filename}"
        copied_images[File.expand_path(gallery_image_path)] = {
          'gallery_path' => File.expand_path(gallery_image_path),
          'original_filename' => filename,
          'dated_filename' => dated_filename,
          'gallery_url' => "/assets/img/gallery/#{dated_filename}",
          'old_gallery_url' => old_gallery_url
        }
      elsif File.exist?(original_gallery_path)
        # File exists with old name, rename it
        FileUtils.mv(original_gallery_path, gallery_image_path)
        puts "  Renamed gallery image: #{filename} → #{dated_filename}"
        # Update the existing_images set
        existing_images.delete(filename)
        existing_images.add(dated_filename)
        # Update the gallery entry in front_matter to use dated filename
        existing_gallery.each do |item|
          if item['image_url'] == filename
            item['image_url'] = dated_filename
            puts "  Updated gallery entry: #{filename} → #{dated_filename}"
          end
        end
        # Track this rename for markdown path updates
        old_gallery_url = "/assets/img/gallery/#{filename}"
        copied_images[File.expand_path(original_gallery_path)] = {
          'gallery_path' => File.expand_path(gallery_image_path),
          'original_filename' => filename,
          'dated_filename' => dated_filename,
          'gallery_url' => "/assets/img/gallery/#{dated_filename}",
          'old_gallery_url' => old_gallery_url
        }
        # Update filename for reference
        filename = dated_filename
      end
      next # Skip adding to new_gallery_items since it's already in gallery
    end
    
    # Check if image exists in gallery directory (try both original and dated names)
    gallery_image_path = File.join(gallery_dir, dated_filename)
    original_gallery_path = File.join(gallery_dir, filename)
    
    # If dated version already exists in gallery directory, use it
    if File.exist?(gallery_image_path)
      filename = dated_filename
    elsif File.exist?(original_gallery_path)
      # Original exists in gallery, rename it to dated version
      FileUtils.mv(original_gallery_path, gallery_image_path)
      puts "  Renamed gallery image: #{filename} → #{dated_filename}"
      # Update the gallery entry in front_matter to use dated filename
      existing_gallery.each do |item|
        if item['image_url'] == filename
          item['image_url'] = dated_filename
          puts "  Updated gallery entry: #{filename} → #{dated_filename}"
        end
      end
      # Track this rename for markdown path updates
      old_gallery_url = "/assets/img/gallery/#{filename}"
      copied_images[File.expand_path(original_gallery_path)] = {
        'gallery_path' => File.expand_path(gallery_image_path),
        'original_filename' => filename,
        'dated_filename' => dated_filename,
        'gallery_url' => "/assets/img/gallery/#{dated_filename}",
        'old_gallery_url' => old_gallery_url
      }
      filename = dated_filename
    else
      # Image doesn't exist in gallery yet, need to copy it
      # Try to find the image in other common locations
      possible_paths = [
        File.join('images', filename),
        File.join('assets/img', filename),
        File.join('assets/img/gallery', filename),
        File.join('assets/images', filename)
      ]
      
      found_path = possible_paths.find { |path| File.exist?(path) }
      
      puts "Found image at #{found_path}, copying to gallery directory as #{dated_filename}..."
      FileUtils.mkdir_p(gallery_dir) unless Dir.exist?(gallery_dir)
      FileUtils.cp(found_path, gallery_image_path)
      
      # Track that we copied this image (for path updates and optional deletion)
      # Store both original filename and dated filename for path updates
      normalized_original = File.expand_path(found_path)
      normalized_gallery = File.expand_path(gallery_image_path)
      copied_images[normalized_original] = {
        'gallery_path' => normalized_gallery,
        'original_filename' => File.basename(found_path),
        'dated_filename' => dated_filename,
        'gallery_url' => "/assets/img/gallery/#{dated_filename}"
      }
      
      # Delete original if requested (only if copy was successful)
      if delete_originals && File.exist?(gallery_image_path)
        FileUtils.rm(found_path)
        puts "  Deleted original image: #{found_path}"
      end
    end
    
    # Generate formatted date string
    date_str = if post_year
                 Date.parse(post_date).strftime('%B %Y')
               else
                 post_year || ''
               end
    
    # Extract post URL slug from filename (remove date prefix and .md extension)
    # Filename format: YYYY-MM-DD-title.md -> title
    post_filename = File.basename(post_file, '.md')
    post_slug = post_filename.sub(/^\d{4}-\d{2}-\d{2}-/, '')
    post_url = "/#{post_slug}/"
    
    # Generate caption: title with link to news post
    caption = if post_title && !post_title.empty?
                "<a href=\"#{post_url}\">#{post_title}</a>"
              else
                "Image from #{date_str}"
              end
    
    # Generate hover caption: just the date
    hover_caption = date_str
    
    # Use dated_filename if we're creating a new entry, otherwise use the filename we found
    final_filename = dated_filename || filename
    
    new_gallery_items << {
      'image_url' => final_filename,
      'caption' => caption,
      'hover_caption' => hover_caption,
      'post_date' => post_date, # For sorting (full date: YYYY-MM-DD)
      'sort_date' => post_date, # Keep for sorting even after merge
      'post_file' => File.basename(post_file) # For reference
    }
    
    posts_with_images += 1
    puts "  Found image: #{filename} from #{File.basename(post_file)}"
  end
end

puts "\nProcessed #{posts_processed} posts"
puts "Found #{posts_with_images} posts with images"
puts "Found #{new_gallery_items.size} new images to add to gallery"

if new_gallery_items.empty?
  puts "\nNo new images to add. Gallery is up to date!"
  exit 0
end

# Sort new items by date (oldest first)
new_gallery_items.sort_by! { |item| item['post_date'] || '' }

# Merge with existing gallery
# For existing items, try to extract date from caption or filename
existing_items_with_dates = existing_gallery.map do |item|
    # Try to extract date from caption (e.g., "Group canoe trip, 2024" or "July 2024")
    date_str = nil
    if item['caption']
      # Try to find date pattern in caption
      # Look for "Month Year" or "YYYY" or "YYYY-MM-DD"
      date_match = item['caption'].match(/(\d{4}-\d{2}-\d{2})|(\w+\s+\d{4})|(\d{4})/)
      if date_match
        date_str = date_match[0]
        # Parse and normalize to YYYY-MM-DD format
        parsed_date = Date.parse(date_str)
        date_str = parsed_date.strftime('%Y-%m-%d')
      end
    end
    
    # If no date in caption, try filename (e.g., "canoe_2024.jpg" -> "2024-01-01")
    unless date_str
      year_match = item['image_url'].match(/_(\d{4})\./)
      if year_match
        date_str = "#{year_match[1]}-01-01"
      end
    end
    
    item.merge('sort_date' => date_str || '0000-01-01')
  end

# Merge new items (keep sort_date, remove post_file)
new_items_merged = new_gallery_items.map { |item| item.reject { |k| k == 'post_file' } }
all_items = existing_items_with_dates + new_items_merged

# Sort all items chronologically by sort_date (oldest first)
all_items.sort_by! { |item| item['sort_date'] || '0000-01-01' }

# Remove sort_date from final output (it was only for sorting)
all_items.each { |item| item.delete('sort_date') }

# Update front matter
front_matter['gallery'] = all_items

# Write updated gallery file
new_front_matter = front_matter.to_yaml
# to_yaml already includes --- at the start, so we don't need to add it again
new_content = "#{new_front_matter}---\n\n{% include gallery %}\n\n"

File.write(gallery_file, new_content)

# Update image paths in all markdown files
# Also handle renaming existing gallery images that don't have date prefixes
if copied_images.any?
  puts "\n📝 Updating image paths in markdown files..."
  updated_files = []
  
  # Track all filename mappings (original -> dated)
  filename_mappings = {}
  
  # Add mappings from copied images
  copied_images.each do |original_path, image_info|
    original_filename = image_info['original_filename']
    dated_filename = image_info['dated_filename']
    gallery_url = image_info['gallery_url']
    old_gallery_url = image_info['old_gallery_url']
    filename_mappings[original_filename] = {
      'dated_filename' => dated_filename,
      'gallery_url' => gallery_url,
      'old_gallery_url' => old_gallery_url
    }
  end
  
  Dir.glob(File.join(posts_dir, '*.md')).each do |post_file|
    post_content = File.read(post_file, encoding: 'UTF-8')
    original_content = post_content.dup
    updated = false
    
    # Update each filename mapping
    filename_mappings.each do |original_filename, mapping|
      dated_filename = mapping['dated_filename']
      gallery_url = mapping['gallery_url']
      old_gallery_url = mapping['old_gallery_url']
      
      # First, update old gallery URLs to new dated gallery URLs (for renamed images)
      if old_gallery_url && post_content.include?(old_gallery_url) && !post_content.include?(gallery_url)
        # Update markdown image syntax: ![alt](old_gallery_url) -> ![alt](gallery_url)
        post_content.gsub!(/!\[([^\]]*)\]\(#{Regexp.escape(old_gallery_url)}\)/) do |match|
          alt_text = $1
          updated = true
          "![#{alt_text}](#{gallery_url})"
        end
        
        # Update HTML image syntax: <img src="old_gallery_url"> -> <img src="gallery_url">
        post_content.gsub!(/<img([^>]+)src=["']#{Regexp.escape(old_gallery_url)}["']([^>]*)>/) do |match|
          before = $1
          after = $2
          updated = true
          "<img#{before}src=\"#{gallery_url}\"#{after}>"
        end
      end
      
      # Then, update any other references to the original filename
      if post_content.include?(original_filename) && !post_content.include?(gallery_url)
        # Update paths in markdown: ![alt](path)
        post_content.gsub!(/!\[([^\]]*)\]\(([^)]*#{Regexp.escape(original_filename)})\)/) do |match|
          alt_text = $1
          old_path = $2
          # Only update if it's not already pointing to the correct gallery URL
          if !old_path.include?(gallery_url) && !old_path.include?("/assets/img/gallery/#{dated_filename}")
            updated = true
            "![#{alt_text}](#{gallery_url})"
          else
            match
          end
        end
        
        # Update paths in HTML: <img src="path">
        post_content.gsub!(/<img([^>]+)src=["']([^"']*#{Regexp.escape(original_filename)})["']([^>]*)>/) do |match|
          before = $1
          old_path = $2
          after = $3
          # Only update if it's not already pointing to the correct gallery URL
          if !old_path.include?(gallery_url) && !old_path.include?("/assets/img/gallery/#{dated_filename}")
            updated = true
            "<img#{before}src=\"#{gallery_url}\"#{after}>"
          else
            match
          end
        end
      end
    end
    
    if updated && post_content != original_content
      File.write(post_file, post_content)
      updated_files << File.basename(post_file)
      puts "  Updated: #{File.basename(post_file)}"
    end
  end
  
  if updated_files.any?
    puts "   Updated #{updated_files.size} post file(s)"
  end
end

puts "\n✅ Successfully updated #{gallery_file}"
puts "   Added #{new_gallery_items.size} new images to gallery"
puts "   Total gallery images: #{all_items.size}"
if delete_originals && copied_images.any?
  puts "   Deleted #{copied_images.size} original image file(s)"
end

