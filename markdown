#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable Style/GlobalVars

require 'yaml'
require 'tabulo'

file = ARGV[0]
$data = YAML.load_file(file)

puts "# #{$data['infinitivo']}"
puts

puts format('Gerundio: %s', $data['infinitivo'])
puts

participio = $data['participio']
if participio.is_a? String
  puts format('Participio: %s', participio)
else
  puts format('Participios: %s', participio.values.join(', '))
end
puts

$pronouns = %w[yo tú vos él ella usted nosotros nosotras vosotros vosotras ellos ellas ustedes]

def capitalize(string)
  string.split.map(&:capitalize).join(' ')
end

def print_mood(mood)
  puts
  puts "## #{mood.capitalize}"
  puts

  header = ['Tense'] + $pronouns.map { |p| capitalize(p) }
  table = []
  $data[mood].each do |tense, forms|
    table << [capitalize(tense)] + $pronouns.map { |p| forms[p] }
  end

  widths = []
  combined = [header] + table
  (0..header.length - 1).each do |i|
    widest = 0
    combined.each do |row|
      cell = row[i]
      cell = cell.join(', ') if cell.is_a? Array
      cell = '' if cell.nil?
      widest = cell.length if cell.length > widest
    end
    widths[i] = widest
  end

  header.each_with_index do |cell, index|
    print '| '
    print capitalize(cell).ljust(widths[index])
    print ' '
  end
  puts ' |'

  header.each_with_index do |cell, index|
    print '|-'
    print '-' * widths[index]
    print '-'
  end
  puts '-|'

  table.each do |row|
    row.each_with_index do |cell, index|
      width = widths[index]
      value = cell.is_a?(Array) ? cell.join(', ') : cell
      value = '' if value.nil?
      print '| '
      print value.ljust(width)
      print ' '
    end
    puts ' |'
  end
end

%w[indicativo subjuntivo imperativo].each { |t| print_mood(t) }
