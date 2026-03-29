#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates llms-full.txt by concatenating all guide markdown files.
# Run from the root of the padrino-docs repo:
#   ruby scripts/generate_llms_txt.rb

require 'yaml'

GUIDES_DIR = File.expand_path('../guides', __dir__)
OUTPUT_FILE = File.expand_path('../llms-full.txt', __dir__)

sections = Dir.glob("#{GUIDES_DIR}/**/*.html.md").sort

File.open(OUTPUT_FILE, 'w') do |out|
  out.puts "# Padrino Framework - Complete Documentation"
  out.puts
  out.puts "Generated from https://github.com/padrino/padrino-docs"
  out.puts "Version: 0.16.1"
  out.puts
  out.puts "---"
  out.puts

  sections.each do |path|
    content = File.read(path)

    # Extract frontmatter
    if content.start_with?('---')
      parts = content.split('---', 3)
      frontmatter = YAML.safe_load(parts[1])
      body = parts[2].strip
      chapter = frontmatter['chapter'] || 'Unknown'
      title = frontmatter['title'] || File.basename(path, '.html.md')
    else
      chapter = 'Unknown'
      title = File.basename(path, '.html.md')
      body = content.strip
    end

    out.puts "# #{chapter}: #{title}"
    out.puts
    out.puts body
    out.puts
    out.puts "---"
    out.puts
  end
end

puts "Generated #{OUTPUT_FILE} (#{File.size(OUTPUT_FILE)} bytes, #{sections.length} guides)"
