#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to convert BibTeX files to Jekyll publications.md page
# Usage: ruby scripts/bibtex_to_publications.rb [preprints.bib] [old_pubs.bib] [new_pubs.bib] [output.md]
# Defaults: assets/jackson_preprints.bib assets/jackson_old_pubs.bib assets/jackson_pubs.bib pages/publications.md

require 'bibtex'
require 'date'
require 'fileutils'

# Parse command line arguments
preprints_file = ARGV[0] || 'assets/jackson_preprints.bib'
old_pubs_file = ARGV[1] || 'assets/jackson_old_pubs.bib'
new_pubs_file = ARGV[2] || 'assets/jackson_pubs.bib'
output_file = ARGV[3] || 'pages/publications.md'

unless File.exist?(preprints_file)
  puts "Warning: Preprints BibTeX file not found: #{preprints_file} (will skip preprints)"
end

unless File.exist?(old_pubs_file)
  puts "Error: Old publications BibTeX file not found: #{old_pubs_file}"
  exit 1
end

unless File.exist?(new_pubs_file)
  puts "Error: New publications BibTeX file not found: #{new_pubs_file}"
  exit 1
end

# Extract publications and group by year/section
publications_by_year = {}

# Helper function to convert a name to "Initials Last" format
def name_to_initials(name)
  return name if name.nil? || name.empty?
  
  name = name.strip
  parts = name.split(/\s+/)
  
  # If only one part, return as-is (might be just last name or single name)
  return name if parts.length == 1
  
  # Last name is the last part
  last_name = parts[-1]
  
  # First and middle names are all parts except the last
  first_middle = parts[0..-2]
  
  # Convert first/middle names to initials
  initials = first_middle.map do |part|
    # If part already contains a period, it's likely already initials (e.g., "J.L.")
    if part.include?('.')
      part
    # Handle hyphenated names like "Chun-I" → "C.-I."
    elsif part.include?('-')
      part.split('-').map { |p| p[0].upcase + '.' }.join('-')
    else
      # Regular name → first letter + period
      part[0].upcase + '.'
    end
  end.join(' ')
  
  "#{initials} #{last_name}"
end

# Helper function to convert BibTeX author format (Last, First) to (Initials Last)
def reformat_authors(author_string)
  return author_string if author_string.nil? || author_string.empty?
  
  # Remove braces if present
  author_string = author_string.gsub(/[{}]/, '').strip
  
  # Check for special case with "..." and "et al."
  # Pattern: "Author1 and ... and Author2 and et al."
  if author_string.match?(/\sand\s\.\.\.\sand\s.*\sand\set\sal/i)
    # Split by " and " to handle multiple authors
    authors = author_string.split(/\s+and\s+/i).map(&:strip)
    
    # Find positions of "..." and "et al"
    ellipsis_idx = authors.index { |a| a == '...' }
    etal_idx = authors.index { |a| a.downcase.include?('et al') }
    
    if ellipsis_idx && etal_idx && ellipsis_idx < etal_idx
      # Format: first author, "...", author before et al, "et al."
      first_author = authors[0]
      # Convert "Last, First" to "First Last" if needed, then to initials
      if first_author.include?(',')
        parts = first_author.split(',', 2).map(&:strip)
        first_author = parts.length == 2 ? "#{parts[1]} #{parts[0]}" : first_author
      end
      first_author = name_to_initials(first_author)
      
      # Find the last author before "et al" (skip any "..." entries)
      before_etal = nil
      (etal_idx - 1).downto(0) do |i|
        if authors[i] != '...'
          before_etal = authors[i]
          break
        end
      end
      
      # Convert "Last, First" to "First Last" if needed, then to initials
      if before_etal && before_etal.include?(',')
        parts = before_etal.split(',', 2).map(&:strip)
        before_etal = parts.length == 2 ? "#{parts[1]} #{parts[0]}" : before_etal
      end
      before_etal = name_to_initials(before_etal) if before_etal
      
      etal_text = authors[etal_idx]
      
      return "#{first_author},..., #{before_etal}, #{etal_text}" if before_etal
    end
  end
  
  # Split by " and " to handle multiple authors
  authors = author_string.split(/\s+and\s+/i)
  
  formatted_authors = authors.map do |author|
    # Skip "..." and "et al" entries for normal processing
    next nil if author == '...' || author.downcase.include?('et al')
    
    author = author.strip
    
    # If author contains a comma, assume "Last, First" format
    if author.include?(',')
      parts = author.split(',', 2).map(&:strip)
      if parts.length == 2
        # Convert "Last, First" to "First Last", then to initials
        name_to_initials("#{parts[1]} #{parts[0]}")
      else
        name_to_initials(author)
      end
    else
      # Already in "First Last" format or single name, convert to initials
      name_to_initials(author)
    end
  end.compact
  
  # Join with commas, except last two authors use "and"
  result = if formatted_authors.length == 0
    ''
  elsif formatted_authors.length == 1
    formatted_authors[0]
  elsif formatted_authors.length == 2
    formatted_authors.join(' and ')
  else
    # All but last two authors joined with commas, then "and" before last author
    formatted_authors[0..-3].join(', ') + ', ' + formatted_authors[-2] + ' and ' + formatted_authors[-1]
  end
  
  # Convert * and ^ to HTML superscripts
  # Each superscript gets its own tag so *^ renders as two separate superscripts
  # Convert ~ (LaTeX non-breaking space) to HTML non-breaking space
  result.gsub(/\*/, '<sup>*</sup>').gsub(/\^/, '<sup>†</sup>').gsub(/~/, '&nbsp;')
end

# Process preprints file - all entries go to "Preprints" section
preprints_bib = nil
if File.exist?(preprints_file)
  puts "Reading preprints BibTeX file: #{preprints_file}"
  preprints_bib = BibTeX.open(preprints_file, encoding: 'UTF-8')

  preprints_bib.each do |entry|
    # Skip non-article entries (you can modify this filter as needed)
    next unless %w[article inproceedings incollection book chapter misc].include?(entry.type.to_s.downcase)
    
    # Extract year
    year = entry.year.to_s
    year = entry.date.to_s.split('-').first if year.empty? && entry.date
    
    # Extract location if specified in BibTeX (for manual control of ordering)
    # Also check for chron_order for backward compatibility
    location = entry.has_field?('location') ? entry.location.to_s.strip : nil
    location = entry.has_field?('chron_order') ? entry.chron_order.to_s.strip : nil if location.nil?
    
    # All entries from preprints.bib go to "Preprints" section
    year = 'Preprints'
    
    # Extract required fields
    authors = entry.author.to_s
    authors = reformat_authors(authors)
    title = entry.title.to_s
    # Use journal-iso if available, otherwise fall back to journal, booktitle, or publisher
    journal = entry.has_field?('journal-iso') ? entry['journal-iso'].to_s : entry.journal.to_s
    journal = entry.booktitle.to_s if journal.empty? && entry.booktitle
    journal = entry.publisher.to_s if journal.empty? && entry.publisher
    
    # Extract DOI, PMID, arxiv, status (for preprints), note, and repo
    doi = entry.has_field?('doi') ? entry.doi.to_s : ''
    pmid = entry.has_field?('pmid') ? entry.pmid.to_s : ''
    arxiv = entry.has_field?('arxiv') ? entry.arxiv.to_s.strip : ''
    status = entry.has_field?('status') ? entry.status.to_s.strip : ''
    note = entry.has_field?('note') ? entry['note'].to_s.strip : ''
    repo = entry.has_field?('repo') ? entry['repo'].to_s.strip : ''
    
    # Extract month if available (for journal formatting and sorting)
    month = entry.has_field?('month') ? entry.month.to_s : ''
    
    # Extract date for sorting (use year-month-day if available)
    date_str = entry.date.to_s if entry.has_field?('date')
    date_str ||= "#{year}-#{month}-01" if !year.empty? && year != 'Preprints' && !month.empty?
    date_str ||= "#{year}-01-01" if !year.empty? && year != 'Preprints'
    date_str ||= '1900-01-01' # Default
    
    # Parse date for sorting (handle various formats)
    sort_date = begin
      Date.parse(date_str)
    rescue
      Date.new(year.to_i, 1, 1) if year != 'Preprints' && !year.empty?
      Date.new(1900, 1, 1)
    end
    
    # Skip if missing essential fields
    next if authors.empty? || title.empty?
    
    # Clean up fields
    authors = authors.gsub(/[\n\r]+/, ' ').strip
    title = title.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
    journal = journal.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
    
    # Format journal with year/month if available
    if !year.empty? && year != 'Preprints' && !journal.empty? && !month.empty?
      journal_parts = [journal]
      journal_parts << year
      journal_parts << month
      journal = journal_parts.join(' ')
    end
    
    # Clean DOI (remove http://dx.doi.org/ prefix if present)
    doi_cleaned = doi && !doi.empty? ? doi.gsub(/^https?:\/\/(dx\.)?doi\.org\//i, '').strip : ''
    
    # For preprints: keep DOI as-is, don't convert to arxiv URL
    # Only use arxiv field for actual arXiv entries (not ChemRxiv)
    
    publications_by_year[year] ||= []
    publications_by_year[year] << {
      authors: authors,
      title: title,
      journal: journal,
      doi: doi_cleaned,
      pmid: pmid,
      arxiv: arxiv,
      status: status,
      note: note,
      repo: repo,
      sort_date: sort_date,
      location: location  # May be nil if not specified in BibTeX
    }
  end
end

# Process old publications file - all entries go to "Prior to UIUC"
puts "Reading old publications BibTeX file: #{old_pubs_file}"
old_bib = BibTeX.open(old_pubs_file, encoding: 'UTF-8')

old_bib.each do |entry|
  # Skip non-article entries (you can modify this filter as needed)
  next unless %w[article inproceedings incollection book chapter misc].include?(entry.type.to_s.downcase)
  
  # Extract year
  year = entry.year.to_s
  year = entry.date.to_s.split('-').first if year.empty? && entry.date
  
  # Extract location if specified in BibTeX (for manual control of ordering)
  # Also check for chron_order for backward compatibility
  location = entry.has_field?('location') ? entry.location.to_s.strip : nil
  location = entry.has_field?('chron_order') ? entry.chron_order.to_s.strip : nil if location.nil?
  
  # All entries from old_pubs.bib go to "Prior to UIUC"
  year = 'Older'
  
  # Extract required fields
  authors = entry.author.to_s
  authors = reformat_authors(authors)
  title = entry.title.to_s
  # Use journal-iso if available, otherwise fall back to journal, booktitle, or publisher
  journal = entry.has_field?('journal-iso') ? entry['journal-iso'].to_s : entry.journal.to_s
  journal = entry.booktitle.to_s if journal.empty? && entry.booktitle
  journal = entry.publisher.to_s if journal.empty? && entry.publisher
  
  # Extract DOI, PMID, note, and repo
  doi = entry.has_field?('doi') ? entry.doi.to_s : ''
  pmid = entry.has_field?('pmid') ? entry.pmid.to_s : ''
  note = entry.has_field?('note') ? entry['note'].to_s.strip : ''
  repo = entry.has_field?('repo') ? entry['repo'].to_s.strip : ''
  
  # Extract month if available (for journal formatting and sorting)
  month = entry.has_field?('month') ? entry.month.to_s : ''
  
  # Extract date for sorting (use year-month-day if available)
  date_str = entry.date.to_s if entry.has_field?('date')
  date_str ||= "#{year}-#{month}-01" if !year.empty? && year != 'Older' && !month.empty?
  date_str ||= "#{year}-01-01" if !year.empty? && year != 'Older'
  date_str ||= '1900-01-01' # Default for older publications
  
  # Parse date for sorting (handle various formats)
  sort_date = begin
    Date.parse(date_str)
  rescue
    Date.new(year.to_i, 1, 1) if year != 'Older' && !year.empty?
    Date.new(1900, 1, 1)
  end
  
  # Skip if missing essential fields
  next if authors.empty? || title.empty?
  
  # Clean up fields
  authors = authors.gsub(/[\n\r]+/, ' ').strip
  title = title.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
  journal = journal.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
  
  # Format journal with year/month if available
  # Match existing format: "Journal Name. YYYY Mon" or just "Journal Name"
  # Only add year/month if month is present (matches existing pattern)
  if !year.empty? && year != 'Older' && !journal.empty? && !month.empty?
    journal_parts = [journal]
    journal_parts << year
    journal_parts << month
    journal = journal_parts.join(' ')
  end
  
  # Clean DOI (remove http://dx.doi.org/ prefix if present)
  doi = doi.gsub(/^https?:\/\/(dx\.)?doi\.org\//i, '').strip if doi
  
  publications_by_year[year] ||= []
  publications_by_year[year] << {
    authors: authors,
    title: title,
    journal: journal,
    doi: doi,
    pmid: pmid,
    note: note,
    repo: repo,
    sort_date: sort_date,
    location: location  # May be nil if not specified in BibTeX
  }
end

# Process new publications file - classify by year normally
puts "Reading new publications BibTeX file: #{new_pubs_file}"
new_bib = BibTeX.open(new_pubs_file, encoding: 'UTF-8')

new_bib.each do |entry|
  # Skip non-article entries (you can modify this filter as needed)
  next unless %w[article inproceedings incollection book chapter misc].include?(entry.type.to_s.downcase)
  
  # Extract year
  year = entry.year.to_s
  year = entry.date.to_s.split('-').first if year.empty? && entry.date
  year = 'Older' if year.empty? || year.to_i < 2016
  
  # Extract location if specified in BibTeX (for manual control of ordering)
  # Also check for chron_order for backward compatibility
  location = entry.has_field?('location') ? entry.location.to_s.strip : nil
  location = entry.has_field?('chron_order') ? entry.chron_order.to_s.strip : nil if location.nil?
  
  # Extract required fields
  authors = entry.author.to_s
  authors = reformat_authors(authors)
  title = entry.title.to_s
  # Use journal-iso if available, otherwise fall back to journal, booktitle, or publisher
  journal = entry.has_field?('journal-iso') ? entry['journal-iso'].to_s : entry.journal.to_s
  journal = entry.booktitle.to_s if journal.empty? && entry.booktitle
  journal = entry.publisher.to_s if journal.empty? && entry.publisher
  
  # Extract DOI, PMID, note, and repo
  doi = entry.has_field?('doi') ? entry.doi.to_s : ''
  pmid = entry.has_field?('pmid') ? entry.pmid.to_s : ''
  note = entry.has_field?('note') ? entry['note'].to_s.strip : ''
  repo = entry.has_field?('repo') ? entry['repo'].to_s.strip : ''
  
  # Extract month if available (for journal formatting and sorting)
  month = entry.has_field?('month') ? entry.month.to_s : ''
  
  # Extract date for sorting (use year-month-day if available)
  date_str = entry.date.to_s if entry.has_field?('date')
  date_str ||= "#{year}-#{month}-01" if !year.empty? && year != 'Older' && !month.empty?
  date_str ||= "#{year}-01-01" if !year.empty? && year != 'Older'
  date_str ||= '1900-01-01' # Default for older publications
  
  # Parse date for sorting (handle various formats)
  sort_date = begin
    Date.parse(date_str)
  rescue
    Date.new(year.to_i, 1, 1) if year != 'Older' && !year.empty?
    Date.new(1900, 1, 1)
  end
  
  # Skip if missing essential fields
  next if authors.empty? || title.empty?
  
  # Clean up fields
  authors = authors.gsub(/[\n\r]+/, ' ').strip
  title = title.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
  journal = journal.gsub(/[\n\r]+/, ' ').gsub(/[{}]/, '').strip
  
  # Format journal with year/month if available
  # Match existing format: "Journal Name. YYYY Mon" or just "Journal Name"
  # Only add year/month if month is present (matches existing pattern)
  if !year.empty? && year != 'Older' && !journal.empty? && !month.empty?
    journal_parts = [journal]
    journal_parts << year
    journal_parts << month
    journal = journal_parts.join(' ')
  end
  
  # Clean DOI (remove http://dx.doi.org/ prefix if present)
  doi = doi.gsub(/^https?:\/\/(dx\.)?doi\.org\//i, '').strip if doi
  
  publications_by_year[year] ||= []
  publications_by_year[year] << {
    authors: authors,
    title: title,
    journal: journal,
    doi: doi,
    pmid: pmid,
    note: note,
    repo: repo,
    sort_date: sort_date,
    location: location  # May be nil if not specified in BibTeX
  }
end

# Sort sections: Preprints first, then years (newest first), then "Older" at the end
sorted_years = publications_by_year.keys.sort do |a, b|
  if a == 'Preprints'
    -1  # Preprints comes first
  elsif b == 'Preprints'
    1
  elsif a == 'Older'
    1   # Older comes last
  elsif b == 'Older'
    -1
  else
    b.to_i <=> a.to_i  # Years sorted newest first
  end
end

# Generate navigation items (Preprints first, then years, then Prior to UIUC)
nav_years = []
nav_years += ['Preprints'] if publications_by_year.key?('Preprints')
regular_years_for_nav = sorted_years.reject { |y| y == 'Preprints' || y == 'Older' }
nav_years += regular_years_for_nav[0..9] # Limit to most recent 10 years for nav
nav_years += ['Older'] if publications_by_year.key?('Older')

# Generate Magellan navigation HTML
nav_html = <<~NAV
<div data-magellan-expedition="fixed">
  <ul class="sub-nav">
NAV

nav_years.each do |year|
  display_name = case year
  when 'Older'
    'Prior to UIUC'
  when 'Preprints'
    'Submitted'
  else
    year
  end
  nav_html += "    <li data-magellan-arrival=\"#{year}\"><a href=\"##{year}\">#{display_name}</a></li>\n"
end

nav_html += <<~NAV
  </ul>
</div>
NAV

# Generate publication includes with numbering
publications_html = ''

# First, calculate numbering
# Separate sections: Preprints, regular years (2021+), and Older
preprints_years = sorted_years.select { |y| y == 'Preprints' }
regular_years = sorted_years.reject { |y| y == 'Preprints' || y == 'Older' }.reverse
older_years = sorted_years.select { |y| y == 'Older' }

# Assign numbers to publications: use BibTeX location if provided, otherwise auto-assign
current_number = 0

# Process Preprints section separately (restarts at 1)
preprints_years.each do |year|
  sorted_pubs = publications_by_year[year].sort_by { |pub| pub[:sort_date] }
  
  # Get list of BibTeX-assigned numbers in this year
  bibtex_numbers = sorted_pubs.select { |p| p[:location] }.map { |p| p[:location].to_i }
  
  # Assign automatic numbers starting from 1, but skip numbers already assigned via BibTeX
  preprints_current = 0
  sorted_pubs.each do |pub|
    if pub[:location]
      # Use BibTeX location as the number
      pub[:number] = pub[:location].to_s
    else
      # Find next available number that's not already used by BibTeX numbers
      preprints_current += 1
      while bibtex_numbers.include?(preprints_current)
        preprints_current += 1
      end
      pub[:number] = preprints_current.to_s
    end
  end
end

# Process regular years (2021+) from oldest to newest for numbering
regular_years.each do |year|
  # Sort all publications chronologically (oldest first) for numbering
  sorted_pubs = publications_by_year[year].sort_by { |pub| pub[:sort_date] }
  
  # Get list of BibTeX-assigned numbers in this year
  bibtex_numbers = sorted_pubs.select { |p| p[:location] }.map { |p| p[:location].to_i }
  
  # Assign automatic numbers only to entries without BibTeX location
  # Assign sequentially, but skip numbers already assigned via BibTeX
  auto_idx = 0
  sorted_pubs.each do |pub|
    unless pub[:location]
      # Find next available sequential number
      candidate = current_number + auto_idx + 1
      while bibtex_numbers.include?(candidate)
        auto_idx += 1
        candidate = current_number + auto_idx + 1
      end
      pub[:number] = candidate.to_s
      auto_idx += 1
    else
      # Use BibTeX location as the number
      pub[:number] = pub[:location].to_s
    end
  end
  
  # Update current_number: use highest number in this year (either BibTeX or auto-assigned)
  all_numbers = publications_by_year[year].map { |p| p[:number].to_i if p[:number] }.compact
  if all_numbers.any?
    max_number = all_numbers.max
    current_number = max_number
  else
    # If no numbers assigned (shouldn't happen), use count
    current_number += sorted_pubs.length
  end
end

# Process "Older" section separately (restarts at 1)
older_years.each do |year|
  sorted_pubs = publications_by_year[year].sort_by { |pub| pub[:sort_date] }
  
  # Get list of BibTeX-assigned numbers in this year
  bibtex_numbers = sorted_pubs.select { |p| p[:location] }.map { |p| p[:location].to_i }
  
  # Assign automatic numbers starting from 1, but skip numbers already assigned via BibTeX
  older_current = 0
  sorted_pubs.each do |pub|
    if pub[:location]
      # Use BibTeX location as the number
      pub[:number] = pub[:location].to_s
    else
      # Find next available number that's not already used by BibTeX numbers
      older_current += 1
      while bibtex_numbers.include?(older_current)
        older_current += 1
      end
      pub[:number] = older_current.to_s
    end
  end
end

# Now generate HTML output in display order (newest first)
sorted_years.each do |year|
  # Set display name for special sections
  display_name = case year
  when 'Older'
    'Prior to UIUC'
  when 'Preprints'
    'Submitted'
  else
    year
  end
  publications_html += "\n<h2 data-magellan-destination=\"#{year}\">#{display_name}</h2>\n"
  publications_html += "<a name=\"#{year}\"></a>\n\n"
  
  # Sort publications within year: if numbers are specified, sort by number (descending for newest first)
  # Otherwise sort by date (oldest first), then reverse for display (newest first)
  sorted_pubs = if publications_by_year[year].any? { |pub| pub[:number] }
    # Sort by number descending (highest number = newest, displayed first)
    publications_by_year[year].sort_by { |pub| pub[:number].to_i }.reverse
  else
    # Fallback to date sorting
    publications_by_year[year].sort_by { |pub| pub[:sort_date] }.reverse
  end
  
  sorted_pubs.each do |pub|
    include_line = '{% include publication'
    include_line += " number=\"#{pub[:number]}\"" if pub[:number]
    include_line += " authors=\"#{pub[:authors].gsub('"', '\\"')}\""
    include_line += " title=\"#{pub[:title].gsub('"', '\\"')}\""
    include_line += " journal=\"#{pub[:journal].gsub('"', '\\"')}\"" unless pub[:journal].empty?
    include_line += " doi=\"#{pub[:doi]}\"" unless pub[:doi].empty?
    include_line += " pmid=\"#{pub[:pmid]}\"" unless pub[:pmid].empty?
    include_line += " arxiv=\"#{pub[:arxiv].gsub('"', '\\"')}\"" unless pub[:arxiv].nil? || pub[:arxiv].empty?
    include_line += " status=\"#{pub[:status].gsub('"', '\\"')}\"" unless pub[:status].nil? || pub[:status].empty?
    include_line += " note=\"#{pub[:note].gsub('"', '\\"')}\"" unless pub[:note].nil? || pub[:note].empty?
    include_line += " repo=\"#{pub[:repo].gsub('"', '\\"')}\"" unless pub[:repo].nil? || pub[:repo].empty?
    include_line += '%}'
    
    publications_html += "#{include_line}\n\n"
  end
end

# Read existing front matter from publications.md if it exists
front_matter = <<~FRONT
---
layout: page-fullwidth
title: "Publications"
meta_title: ""
subheadline: ""
teaser: ""
permalink: "/publications/"
header:
    # Banner image uses site.background_banner from _config.yml (can override per page if needed)
---
FRONT

# If output file exists, try to preserve front matter
if File.exist?(output_file)
  existing_content = File.read(output_file, encoding: 'UTF-8')
  if existing_content =~ /^---\n.*?\n---\n/m
    front_matter = $&
  end
end

# Add note text before publications
note_text = <<~NOTE

For the most up-to-date information please see [Google Scholar Profile](https://scholar.google.com/citations?user=xFw-Ab0AAAAJ&hl=en) or [ORCID](https://orcid.org/0000-0002-1470-1903).

<sup>*</sup> denotes corresponding author, <sup>†</sup> denotes equal contributions.

NOTE

# Combine everything
output_content = front_matter + "\n" + nav_html + note_text + publications_html

# Write output file
puts "Writing output to: #{output_file}"

# Create backup if file exists
if File.exist?(output_file)
  backup_file = "#{output_file}.backup"
  FileUtils.cp(output_file, backup_file)
  puts "  Created backup: #{backup_file}"
end

File.write(output_file, output_content, encoding: 'UTF-8')

puts "Successfully generated #{output_file}"
if preprints_bib
  puts "  Processed #{preprints_bib.length} entries from #{preprints_file}"
end
puts "  Processed #{old_bib.length} entries from #{old_pubs_file}"
puts "  Processed #{new_bib.length} entries from #{new_pubs_file}"
puts "  Generated #{publications_by_year.values.sum(&:length)} publications"
puts "  Organized into #{sorted_years.length} sections"

