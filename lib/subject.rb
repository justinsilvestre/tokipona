require_relative 'substantive'
require_relative 'word_classes'
require_relative 'indexable'

class Subject
	include SubstantiveComponents
	include Indexable

	attr_accessor :words, :index_start

	def initialize(original, index_start=0)
		self.words = original
		self.index_start = index_start
	end

	def conjunctions
		return @conjunctions if defined? @conjunctions
		@conjunctions = words.map{ |w| w.match(Regexp.union CONJUNCTIONS) ? $& : nil }.reject(&:nil?)
	end

	def components
		return @components if defined? @components
		@components = []
		if conjunctions
			component_strings = words.join(' ').split(Regexp.union CONJUNCTIONS)
			component_strings.each do |component_string|
				@components << new_component(component_string.split,
					role: 'subj', index_start: all_indices(@components) + index_start)
			end
		else
			@components = [new_component(words, role: subj, index_start: index_start)]
		end
		@components
	end

	def tree
		@tree = {}
		@tree[:components] = components.map(&:tree)
		@tree[:conjunctions] = conjunctions if conjunctions.any?
		@tree
	end

	def [](i)
		components[i]
	end
end