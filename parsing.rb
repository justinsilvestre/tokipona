require_relative 'sentence'
require 'json'

class Parsing
	attr_reader :original_text

	def initialize(text)
		@original_text = text
	end

	def sentences
		return @sentences if defined? @sentences
		sentences = original_text.split(/([!?\.,:])/).each_slice(2).map(&:join)
		i = 0
		while i < sentences.length do 
			sentences[i] = sentences[i] + sentences.delete_at(i+1) if (sentences[i].match /,$/) and !(sentences[i+1].strip.match /^taso/)
			i += 1
		end
		@sentences = sentences.map do |sen|
			Sentence.new sen.strip
		end
	end

	def analysis
		@analysis ||= sentences.map(&:analysis)
	end

	def json
		analysis.to_json
	end

	def color_analysis
		sentences.map do |sentence|
			sentence.color_analysis
		end
	end

	def color_json
		color_analysis.to_json
	end
end