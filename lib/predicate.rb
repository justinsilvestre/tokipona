require_relative 'indexable'

class Predicate
	include SubstantiveComponents
	include Indexable

	attr_reader :words
	attr_reader :clause
	attr_reader :modal_particle
	attr_reader :index_start

	def initialize(original, index_start=0)
		@words = original
		@index_start = index_start
	end

	def words_without_first_particle
		words_without_first_particle = words.first == modal_particle ? words[1..-1] : words
	end

	def components
		return @components if defined? @components
		@components = []
		components_text = words.join(' ').split(/\b(?:o|li|anu|\A)\b/).reject(&:empty?)
		components_text.each do |component_text|
			new_index_start = all_indices(@components) + index_start
			@components << new_component(component_text.strip.split, role: 'pred', index_start: new_index_start)
		end
		@components
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
end