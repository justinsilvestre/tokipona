#!/usr/bin/env ruby

require 'csv'
require 'json'

file_in_name = ARGV[0]

file_out_name = file_in_name.sub(/\.csv/,".json")
file_out = File.open(file_out_name, "w")

words_hash = {}
CSV.foreach(file_in_name) do |row|
	entry_head = row[0]
	words_hash[entry_head] ||= {}
	entry = words_hash[entry_head]

	part_of_speech = row[1]

	if part_of_speech == 'alt'
		entry[:principle] = row[2]
		words_hash[entry[:principle]]['alt'] = entry_head
	else
		entry[part_of_speech] = []
		(2...row.length).each do |i|
			entry[part_of_speech] << row[i]
		end
	end
end

file_out.puts JSON.generate(words_hash)

file_out.close()


# entries with alt can only have one part of speech