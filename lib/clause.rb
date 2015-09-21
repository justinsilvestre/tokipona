require_relative 'subject'
require_relative 'predicate'

class Clause
	include Indexable

	attr_accessor :words
	attr_accessor :index_start

	def initialize(original, index_start=0)
		self.words = original
		@index_start = index_start
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
			@subject = Subject.new words[0...words.index('li')],  index_start
		elsif %w'mi sina'.include? words.first
			@subject = Subject.new [words.first], index_start
		else
			@subject = nil
		end
	end

	def predicate
		return @predicate if defined? @predicate
		@predicate = Predicate.new words[initial_index..final_index], predicate_index
	end

	def tree
		@tree = {}
		@tree[:subject] = subject.tree if subject
		@tree[:predicate] = predicate.tree
		@tree
	end

	private

		def components
			[subject, predicate].reject(&:nil?)
		end

		def predicate_index
			shift = subject ? subject.indices : 1
			return shift + index_start
		end
end