require_relative 'subject'
require_relative 'predicate'

class Clause
	attr_accessor :words
	def initialize(original)
		self.words = original
	end

	def subject
		return @subject if defined? @subject
		if words.include? 'o'
			@subject = Subject.new words[0...words.index('o')]
		elsif words.include? 'li'
			@subject = Subject.new words[0...words.index('li')]
		elsif %w'mi sina'.include? words.first
			@subject = Subject.new([ words.first ])
		else
			@subject = nil
		end
	end

	def predicate
		return @predicate if defined? @predicate
		if subject.nil?
			@predicate = Predicate.new words
		else
			@predicate = Predicate.new words[words.index('li')..-1]
		end
	end
end