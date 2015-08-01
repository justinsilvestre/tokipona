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
		sentences.each_with_index do |sentence, i|
			if sentence.match(/,$/) and !sentences[i+1].strip.match(/^taso/)
				sentence = sentence + sentences[i+1]
				sentences.delete_at i+1
			end
		end
		@sentences = sentences.map do |sen|
			Sentence.new sen.strip
		end
	end

	def analysis
		@analysis ||= sentences.map(&:analysis)
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