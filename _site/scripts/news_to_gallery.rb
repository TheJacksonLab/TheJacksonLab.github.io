#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to automatically add images from news posts to the team gallery
# Usage: ruby scripts/news_to_gallery.rb [gallery_page]
# Default: pages/team-gallery.md

require 'yaml'
require 'date'
require 'fileutils'
require 'set'

gallery_file = ARGV[0] || 'pages/team-gallery.md'
posts_dir = '_posts'
gallery_dir = 'assets/img/gallery'

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
    
    # Skip if already in gallery
    next if existing_images.include?(filename)
    
    # Check if image exists in gallery directory
    gallery_image_path = File.join(gallery_dir, filename)
    unless File.exist?(gallery_image_path)
      # Try to find the image in other common locations
      possible_paths = [
        File.join('images', filename),
        File.join('assets/img', filename),
        File.join('assets/images', filename)
      ]
      
      found_path = possible_paths.find { |path| File.exist?(path) }
      
      if found_path
        puts "Found image at #{found_path}, copying to gallery directory..."
        FileUtils.mkdir_p(gallery_dir) unless Dir.exist?(gallery_dir)
        FileUtils.cp(found_path, gallery_image_path)
      else
        puts "Warning: Image #{filename} from post #{File.basename(post_file)} not found in gallery directory or common locations"
        puts "  Please manually copy the image to #{gallery_dir}/#{filename}"
        next
      end
    end
    
    # Generate caption from post title and date
    date_str = if post_year
                 Date.parse(post_date).strftime('%B %Y') rescue post_year
               else
                 post_year || ''
               end
    
    caption = if post_title && !post_title.empty?
                "#{post_title}, #{date_str}"
              else
                "Image from #{date_str}"
              end
    
    # Generate hover caption (shorter version)
    hover_caption = if post_title && !post_title.empty?
                      # Extract key words from title (first few words)
                      words = post_title.split(/\s+/).first(3).join(' ')
                      "#{words} #{post_year}"
                    else
                      "#{date_str}"
                    end
    
    new_gallery_items << {
      'image_url' => filename,
      'caption' => caption,
      'hover_caption' => hover_caption,
      'post_date' => post_date, # For sorting
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

# Merge with existing gallery and sort by year
all_items = existing_gallery + new_gallery_items.map { |item| item.reject { |k| k == 'post_date' || k == 'post_file' } }

# Sort all items by extracting year from caption or image_url
all_items.sort_by! do |item|
  # Try to extract year from image_url (e.g., "canoe_2025.jpg" -> 2025)
  year_match = item['image_url'].match(/_(\d{4})\./)
  if year_match
    year_match[1].to_i
  else
    # Try to extract from caption
    caption_year = item['caption'].match(/(\d{4})/)
    caption_year ? caption_year[1].to_i : 0
  end
end

# Update front matter
front_matter['gallery'] = all_items

# Write updated gallery file
new_front_matter = front_matter.to_yaml
new_content = "---\n#{new_front_matter}---\n\n{% include gallery %}\n\n"

File.write(gallery_file, new_content)

puts "\n✅ Successfully updated #{gallery_file}"
puts "   Added #{new_gallery_items.size} new images to gallery"
puts "   Total gallery images: #{all_items.size}"

