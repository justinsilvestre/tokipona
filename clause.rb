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

	def initial_index
		subject.nil? ? 0 : subject.words.length
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
		if words.include? 'o'
			i = words.index 'o'
			@subject = i == 0 ? nil : Subject.new(words[0...i]) 
		elsif words.include? 'li'
			@subject = Subject.new words[0...words.index('li')]
		elsif %w'mi sina'.include? words.first
			@subject = Subject.new [words.first]
		else
			@subject = nil
		end
	end

	def predicate
		return @predicate if defined? @predicate
		@predicate = Predicate.new words[initial_index..final_index], modal_particle
	end

	def analysis
		@analysis = {}
		@analysis[:subject] = subject.analysis if subject
		@analysis[:predicate] = predicate.analysis
		@analysis
	end
end