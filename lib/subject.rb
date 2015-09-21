require_relative 'word_classes'
require_relative 'indexable'
require_relative 'substantive'

class Subject
	include SubstantiveComponents
	include Indexable

	attr_accessor :words, :index_start, :in_context

	def initialize(original, index_start=0, in_context=false)
		@words = original
		@index_start = index_start
		@in_context = in_context
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
					role: role, index_start: all_indices(@components) + index_start)
			end
		else
			@components = [new_component(words, role: role, index_start: index_start)]
		end
		@components
	end

	def role
		in_context ? 'csub' : 'subj'
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

	def analysis
		@analysis = components.map.with_index do |component, i|
			particle_info = i > 0 ? { particle: conjunctions[i-1] } : {}
			component.analysis.first.merge(particle_info)
		end
	end

	def analysis
		components.inject([]) do |analyses, component|
			analyses + component.analyses_with_children
		end
	end
end