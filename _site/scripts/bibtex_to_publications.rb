#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to convert BibTeX file to Jekyll publications.md page
# Usage: ruby scripts/bibtex_to_publications.rb input.bib [output.md]

require 'bibtex'
require 'date'
require 'fileutils'

# Parse command line arguments
if ARGV.length < 1
  puts "Usage: ruby scripts/bibtex_to_publications.rb <input.bib> [output.md]"
  puts "  input.bib: Path to BibTeX file"
  puts "  output.md: Optional path to output file (default: pages/publications.md)"
  exit 1
end

input_file = ARGV[0]
output_file = ARGV[1] || 'pages/publications.md'

unless File.exist?(input_file)
  puts "Error: BibTeX file not found: #{input_file}"
  exit 1
end

# Read and parse BibTeX file
puts "Reading BibTeX file: #{input_file}"
bib = BibTeX.open(input_file, encoding: 'UTF-8')

# Extract publications and group by year
publications_by_year = {}

bib.each do |entry|
  # Skip non-article entries (you can modify this filter as needed)
  next unless %w[article inproceedings incollection book chapter].include?(entry.type.to_s.downcase)
  
  # Extract year
  year = entry.year.to_s
  year = entry.date.to_s.split('-').first if year.empty? && entry.date
  year = 'Older' if year.empty? || year.to_i < 2016
  
  # Extract required fields
  authors = entry.author.to_s
  title = entry.title.to_s
  journal = entry.journal.to_s
  journal = entry.booktitle.to_s if journal.empty? && entry.booktitle
  journal = entry.publisher.to_s if journal.empty? && entry.publisher
  
  # Extract DOI and PMID
  doi = entry.has_field?('doi') ? entry.doi.to_s : ''
  pmid = entry.has_field?('pmid') ? entry.pmid.to_s : ''
  
  # Extract month if available (for journal formatting)
  month = entry.has_field?('month') ? entry.month.to_s : ''
  
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
    pmid: pmid
  }
end

# Sort years (newest first), with "Older" and "All" at the end
sorted_years = publications_by_year.keys.sort do |a, b|
  if a == 'Older' || a == 'All'
    1
  elsif b == 'Older' || b == 'All'
    -1
  else
    b.to_i <=> a.to_i
  end
end

# Generate navigation items (years present in data + standard ones)
nav_years = sorted_years.reject { |y| y == 'Older' || y == 'All' }
nav_years = nav_years[0..9] # Limit to most recent 10 years for nav
nav_years += ['Older', 'All'] if publications_by_year.key?('Older')

# Generate Magellan navigation HTML
nav_html = <<~NAV
<div data-magellan-expedition="fixed">
  <ul class="sub-nav">
NAV

nav_years.each do |year|
  nav_html += "    <li data-magellan-arrival=\"#{year}\"><a href=\"##{year}\">#{year}</a></li>\n"
end

nav_html += <<~NAV
  </ul>
</div>
NAV

# Generate publication includes
publications_html = ''

sorted_years.each do |year|
  publications_html += "\n<h2 data-magellan-destination=\"#{year}\">#{year}</h2>\n"
  publications_html += "<a name=\"#{year}\"></a>\n\n"
  
  publications_by_year[year].each do |pub|
    include_line = '{% include publication'
    include_line += " authors=\"#{pub[:authors].gsub('"', '\\"')}\""
    include_line += " title=\"#{pub[:title].gsub('"', '\\"')}\""
    include_line += " journal=\"#{pub[:journal].gsub('"', '\\"')}\""
    include_line += " doi=\"#{pub[:doi]}\"" unless pub[:doi].empty?
    include_line += " pmid=\"#{pub[:pmid]}\"" unless pub[:pmid].empty?
    include_line += '%}'
    
    publications_html += "#{include_line}\n\n"
  end
end

# Add footer section
footer_html = <<~FOOTER

<h2 data-magellan-destination="All">Complete Bibliography (PubMed)</h2>
<a name="All"></a>

<h3><a href="https://www.ncbi.nlm.nih.gov/myncbi/obi.griffith.1/bibliography/public/">Obi Griffith</a></h3>

<h3><a href="https://www.ncbi.nlm.nih.gov/myncbi/malachi.griffith.1/bibliography/public/">Malachi Griffith</a></h3>
FOOTER

# Read existing front matter from publications.md if it exists
front_matter = <<~FRONT
---
layout: page-fullwidth
title: "Selected Publications"
meta_title: ""
subheadline: ""
teaser: ""
permalink: "/publications/"
header:
    image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
---
FRONT

# If output file exists, try to preserve front matter
if File.exist?(output_file)
  existing_content = File.read(output_file, encoding: 'UTF-8')
  if existing_content =~ /^---\n.*?\n---\n/m
    front_matter = $&
  end
end

# Combine everything
output_content = front_matter + "\n" + nav_html + publications_html + footer_html

# Write output file
puts "Writing output to: #{output_file}"

# Create backup if file exists
if File.exist?(output_file)
  backup_file = "#{output_file}.backup.#{Time.now.strftime('%Y%m%d_%H%M%S')}"
  FileUtils.cp(output_file, backup_file)
  puts "  Created backup: #{backup_file}"
end

File.write(output_file, output_content, encoding: 'UTF-8')

puts "Successfully generated #{output_file}"
puts "  Processed #{bib.length} BibTeX entries"
puts "  Generated #{publications_by_year.values.sum(&:length)} publications"
puts "  Organized into #{sorted_years.length} year sections"

