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
			@subject = i == 0 ? nil : new_subject(words[0...i])
		elsif words.include? 'li'
			@subject = new_subject words[0...words.index('li')]
		elsif %w'mi sina'.include? words.first
			@subject = new_subject [words.first]
		else
			@subject = nil
		end
	end

	def predicate
		return @predicate if defined? @predicate
		@predicate = Predicate.new words[initial_index..final_index], predicate_index, is_context?
	end

	def tree
		@tree = {}
		@tree[:subject] = subject.tree if subject
		@tree[:predicate] = predicate.tree
		@tree
	end

	def analysis
		subject_analysis = subject ? subject.analysis : []
		subject_analysis + predicate.analysis
	end

	private

		def components
			[subject, predicate].reject(&:nil?)
		end

		def new_subject(words)
			Subject.new words, index_start, is_context?
		end

		def predicate_index
			subject_indices = subject ? subject.indices : 0
			return index_start + subject_indices
		end
end