require_relative 'indexable'

class Predicate
	include SubstantiveComponents
	include Indexable

	attr_reader :words
	attr_reader :modal_particle
	attr_reader :index_start, :in_context

	def initialize(original, index_start=0, in_context=false)
		@words = original
		@index_start = index_start
		@in_context = in_context
	end

	def words_without_first_particle
		words_without_first_particle = words.first == modal_particle ? words[1..-1] : words
	end

	def components
		return @components if defined? @components
		@components = []
		component_strings.each_with_index do |component_string, i|
			component_options = { role: in_context ? 'cpre' : 'pred', index_start: new_component_index }.merge(particle_info(i))
			@components << new_component(component_string.strip.split, component_options )
		end
		@components
	end

	def role
		in_context ? 'cpre' : 'pred'
	end

	def component_strings
		component_strings = words.join(' ').split(/\b(?:o|li|anu|\A)\b/).reject(&:empty?)
	end

	def new_component_index
		all_indices(@components) + index_start
	end

	def tree
		@tree = components.map &:tree
	end

	def [](i)
		components[i]
	end

	def particles
		@particles ||= words.join(' ').scan /\b(?:o|li|anu|\A)\b/
	end

	def analysis
		components.inject([]) do |analyses, component|
			analyses + component.analyses_with_children
		end
	end

	def particle_info(component_index)
		particles[component_index].empty? ? {} : { particle: particles[component_index] }
	end
end