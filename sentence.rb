require_relative 'clause'
require_relative 'vocative'
require_relative 'context'

class Sentence
	# remember to enforce proper capitalization
	attr_reader :original_text
	attr_accessor :words

	def initialize(text)
		@original_text = text
		# later, throw error if more than one occurence of o
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
		@emphatic =  last_word == 'a' || last_word == 'kin' ? [last_word] : nil
	end

	def without_emphatic
		return @without_emphatic if defined? @without_emphatic
		@without_emphatic ||= emphatic.nil? ? words : formatted.gsub(/\sa$|\skin$/, '').split
	end

	def vocative
		return @vocative if defined? @vocative
		has_vocative = (without_emphatic[-1] == 'o') || (original_text.match /\so[,:]/)
		@vocative = has_vocative ? Vocative.new(words[0..words.index('o')]) : nil
	end

	def without_vocative_or_emphatic
		return @without_vocative_or_emphatic if defined? @without_vocative_or_emphatic
		@without_vocative_or_emphatic = vocative.nil? ? without_emphatic : without_emphatic[1+words.index('o')..-1]
	end

	def context
		return @context if defined? @context
		chunk = without_vocative_or_emphatic
		@context = chunk.include?('la') ?
			Context.new(chunk[0..chunk.index('la')]) : nil
	end

	def question_tag
		return @question_tag if defined? @question_tag
		question_tag = %w'anu seme'
		if without_vocative_or_emphatic[-2..-1] == question_tag
			@question_tag = question_tag
		else
			@question_tag = nil
		end
	end

	def clause
		return @clause if defined? @clause
		if !context.nil?
			@clause = Clause.new without_vocative_or_emphatic[without_emphatic.index('la')+1..-1]
		elsif without_vocative_or_emphatic.empty?
			@clause = nil
		else
			@clause = Clause.new without_vocative_or_emphatic
		end
	end

	def subject
		clause.subject
	end

	def predicate
		clause.predicates
	end
end