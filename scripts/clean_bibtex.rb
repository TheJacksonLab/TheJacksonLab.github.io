#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to clean BibTeX file, keeping only specified fields
# Usage: ruby scripts/clean_bibtex.rb input.bib [output.bib]

require 'fileutils'

# Fields to keep
KEEP_FIELDS = %w[
  author
  journal
  title
  year
  doi
  volume
  issue
  journal-iso
  number
  pages
].freeze

# Parse command line arguments
if ARGV.length < 1
  puts "Usage: ruby scripts/clean_bibtex.rb <input.bib> [output.bib]"
  puts "  input.bib: Path to input BibTeX file"
  puts "  output.bib: Optional path to output file (default: overwrites input)"
  exit 1
end

input_file = ARGV[0]
output_file = ARGV[1] || input_file

unless File.exist?(input_file)
  puts "Error: BibTeX file not found: #{input_file}"
  exit 1
end

# Read the BibTeX file
puts "Reading BibTeX file: #{input_file}"
content = File.read(input_file, encoding: 'UTF-8')

# Create backup
if File.exist?(output_file)
  backup_file = "#{output_file}.backup.#{Time.now.strftime('%Y%m%d_%H%M%S')}"
  FileUtils.cp(output_file, backup_file)
  puts "  Created backup: #{backup_file}"
end

# Split into entries (entries start with @)
entries = content.split(/^@/).reject(&:empty?)

cleaned_entries = []

entries.each do |entry_text|
  # Re-add the @ symbol
  full_entry = "@#{entry_text}"
  
  # Extract entry type and key (first line)
  first_line = full_entry.lines.first
  entry_header = first_line.strip
  
  # Extract all field lines
  field_lines = full_entry.lines[1..-1] || []
  
  # Parse fields
  kept_fields = []
  field_lines.each do |line|
    # Match BibTeX field format: fieldname = {value},
    if line =~ /^\s*([a-zA-Z0-9-]+)\s*=\s*(.+?)(?:,\s*)?$/
      field_name = $1.strip
      field_value = $2.strip
      
      # Remove trailing comma from value if present
      field_value = field_value.chomp(',')
      
      # Keep only specified fields
      if KEEP_FIELDS.include?(field_name)
        # Preserve the original formatting
        indent = line[/^\s*/]
        kept_fields << "#{indent}#{field_name} = #{field_value},"
      end
    end
  end
  
  # Reconstruct entry
  if kept_fields.any?
    cleaned_entry = "#{entry_header}\n"
    cleaned_entry += kept_fields.join("\n")
    cleaned_entry += "\n}"
    cleaned_entries << cleaned_entry
  end
end

# Write cleaned BibTeX
puts "Writing cleaned BibTeX to: #{output_file}"

File.open(output_file, 'w', encoding: 'UTF-8') do |f|
  cleaned_entries.each do |entry|
    f.puts entry
    f.puts
  end
end

puts "Successfully cleaned BibTeX file"
puts "  Kept #{KEEP_FIELDS.length} fields: #{KEEP_FIELDS.join(', ')}"
puts "  Processed #{cleaned_entries.length} entries"
