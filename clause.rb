require_relative 'subject'
require_relative 'predicate'

class Clause
	attr_accessor :words
	def initialize(original, options={})
		self.words = original
	end

	def is_context?
		words.last == 'la'
	end

	def final_index
		is_context? ? -2 : -1
	end

	def mood
		@mood ||= (words.include? 'o') ? :optative : :indicative
	end

	def modal_particle
		@modal_particle ||= mood == :optative ? 'o' : 'li'
	end

	def subject
		return @subject if defined? @subject
		if (words.include? 'o') || (words.include? 'li')
			@subject = Subject.new words[0...words.index(modal_particle)]
		elsif %w'mi sina'.include? words.first
			@subject = Subject.new([ words.first ])
		else
			@subject = nil
		end
	end

	def predicate
		return @predicate if defined? @predicate
		predicate_words = subject.nil? ? words : words[subject.words.length..final_index]
		@predicate = Predicate.new predicate_words, modal_particle
	end

	def analysis
		@analysis = {}
		@analysis[:subject] = subject.analysis if subject
		@analysis[:predicate] = predicate.analysis
	end
end