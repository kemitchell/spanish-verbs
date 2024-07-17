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

%w[indicativo subjunctivo imperativo].each do |mood|
  data[mood].each_value do |value|
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
  end
end

File.write(file, YAML.dump(data))
