class Predicate
	attr_reader :words
	attr_reader :clause
	attr_reader :modal_particle

	def initialize(original, modal_particle)
		@words = original
		@modal_particle = modal_particle
	end

	def components
		return @components if defined? @components
		@components = []
		without_first_particle = words.first == modal_particle ? words[1..-1] : words
		@components = without_first_particle.join(' ').split(" #{modal_particle} ").map do |component_text|
			Substantive.new component_text.split
		end
	end

	def analysis
		@analysis = components.map &:analysis
	end
end