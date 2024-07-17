#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

file = ARGV[0]
data = YAML.load_file(file)

pronoun_groups = [
  %w[él ella usted],
  %w[nosotros nosotras],
  %w[vosotros vosotras],
  %w[ellos ellas ustedes]
]

pronoun_order = %w[yo tú vos él ella usted nosotros nosotras vosotros vosotras ellos ellas ustedes]

%w[indicativo subjunctivo imperativo].each do |mood|
  data[mood].each do |key, value|
    pronoun_groups.each do |group|
      present = []
      missing = []
      group.each do |pronoun|
        if value.include? pronoun
          present << pronoun
        else
          missing << pronoun
        end
      end
      next if present.empty? || missing.empty?

      missing.each do |fill|
        value[fill] = value[present[0]]
      end
    end
    old_object = data[mood][key]
    new_object = {}
    keys = old_object.keys.sort_by { |p| pronoun_order.find_index(p) }
    keys.each { |k| new_object[k] = old_object[k] }
    data[mood][key] = new_object
  end
end

File.write(file, YAML.dump(data))
