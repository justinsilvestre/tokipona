require_relative 'sentence'
require 'json'

class Parsing
	attr_reader :original_text

	def initialize(text)
		@original_text = text.gsub(/[^a-zA-Z\s!\?\.,:;]/,'')
	end

	def sentences
		return @sentences if defined? @sentences
		raw_sentences = original_text.clone
		@sentences = []
		chunk_regex = /[^!\?\.,:]+[!\?\.,:]*^*/

		# properly, should check for taso after vocative (maybe...)
		while raw_sentences.match /[a-zA-Z]+/ do
			chunk = raw_sentences.slice!(chunk_regex)
			break if !chunk
			if !(@sentences.empty?) && (@sentences[-1].match(/,[a-zA-Z]*$/))
				if (chunk.match(/^[^a-zA-Z]taso/))
					@sentences << chunk.strip
				else
					@sentences[-1] = @sentences[-1] + chunk 
				end
			else
				@sentences << chunk.strip
			end
			# if delimiter of last is comma and current
			# chunk does not begin with taso, add current chunk to last chunk
		end
		@sentences = @sentences.map { |s| Sentence.new s }
	end

	def analysis
		@analysis ||= sentences.map(&:analysis)
	end

	def json
		analysis.to_json
	end
end