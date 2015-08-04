require_relative 'clause'
require_relative 'vocative'
require_relative 'context'

class Sentence
	# remember to enforce proper capitalization
	attr_reader :original_text
	attr_accessor :words

	def initialize(text)
		@original_text = text
		# later, throw error if more than one occurence of o etc.
	end

	def formatted
		@formatted ||= original_text.gsub(/[^A-Za-z\s]/, '').strip
	end

	def words
		@words ||= formatted.split
	end

	def emphatic
		return @emphatic if defined? @emphatic
		last_word = words[-1]
		@emphatic =  last_word == 'a' || last_word == 'kin' ? last_word : nil
	end

	def without_periphery
		return @without_periphery if defined? @without_periphery
		@without_periphery ||= formatted.match(/\sa$|\skin$|^taso/).nil? ? words : formatted.gsub(/\sa$|\skin$|^taso/, '').split
	end

	def vocative
		return @vocative if defined? @vocative
		has_vocative = (without_periphery[-1] == 'o') || (original_text.match /\so[,:]/)
		@vocative = has_vocative ? Vocative.new(words[0..words.index('o')]) : nil
	end

	def without_vocative_or_periphery
		return @without_vocative_or_periphery if defined? @without_vocative_or_periphery
		@without_vocative_or_periphery = vocative.nil? ? without_periphery : without_periphery[1+words.index('o')..-1]
	end

	def context
		return @context if defined? @context
		chunk = without_vocative_or_periphery
		@context = chunk.include?('la') ?
			Clause.new(chunk[0..chunk.index('la')]) : nil
	end

	def question_tag
		return @question_tag if defined? @question_tag
		question_tag = %w'anu seme'
		if without_vocative_or_periphery[-2..-1] == question_tag
			@question_tag = question_tag
		else
			@question_tag = nil
		end
	end

	def clause
		return @clause if defined? @clause
		if !context.nil?
			@clause = Clause.new without_vocative_or_periphery[without_periphery.index('la')+1..-1]
		elsif without_vocative_or_periphery.empty?
			@clause = nil
		else
			@clause = Clause.new without_vocative_or_periphery
		end
	end

	def subject
		clause.subject
	end

	def predicate
		clause.predicate
	end

	def end_punctuation
		original_text.match(/[^a-zA-Z]*$/)[0]
	end

	def mood
		clause.mood
	end

	def analysis
		@analysis = {}
		@analysis[:vocative] = vocative.analysis if vocative
		@analysis[:context] = context.analysis if context
		@analysis[:subject] = subject.analysis if subject
		@analysis[:predicate] = predicate.analysis
		@analysis[:emphatic] = emphatic if emphatic
		@analysis[:taso] = 'taso' if original_text.match(/^\s*taso/)
		@analysis[:end_punctuation] = end_punctuation
		@analysis[:mood] = mood
		@analysis
	end
end