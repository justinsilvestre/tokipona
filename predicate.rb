class Predicate
	attr_reader :words
	attr_reader :clause

	def initialize(original, clause)
		@words = original
		@clause = clause
	end

	def components
		return @components if defined? @components
		@components = []
		without_first_particle = words.first == clause.modal_particle ? words[1..-1] : words
		@components = without_first_particle.join(' ').split(" #{clause.modal_particle} ").map do |component_text|
			Substantive.new component_text.split
		end
	end

	def [](i)
		components[i]
	end
end