require_relative 'subject'
require_relative 'predicate'

class Clause
	attr_accessor :words
	def initialize(original)
		self.words = original
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
			@modal_particle = 'o'
			@subject = Subject.new words[0...words.index('o')]
		elsif words.include? 'li'
			@subject = Subject.new words[0...words.index('li')]
		elsif %w'mi sina'.include? words.first
			@subject = Subject.new([ words.first ])
		else
			@subject = nil
		end
	end

	def predicate_delimiters
		return @delimiters if defined? @delimiters
		@delimiters = []
		@delimiters << 1 if ([['mi'],['sina']].include? subject.words)
		words.each_with_index do |word, i|
			@delimiters << i if word == modal_particle
		end
		@delimiters
	end

	def predicates
		return @predicates if defined? @predicates
		@predicates = []
		if subject.nil?
			add_predicate words
		else
			predicate_delimiters.length.times do |i|
				start = predicate_delimiters[i]
				finish = predicate_delimiters[i+1].nil? ? -1 : predicate_delimiters[i+1]
				add_predicate words[start..finish]
			end
		end
		@predicates
	end

	def add_predicate(new_words)
		@predicates << Predicate.new(new_words, self)
	end
end