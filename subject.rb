require_relative 'substantive'
class Subject
	attr_accessor :words

	def initialize(original)
		self.words = original
	end

	def conjunction
		return @conjunction if defined? @conjunction
		@conjunction = words.include?('en') ? 'en' : nil
	end

	def components
		return @components if defined? @components
		if conjunction
			@components = words.join(' ').split(' en ').map do |component_string|
				Substantive.new(component_string.split)
			end
		else
			@components = [Substantive.new(words)]
		end
	end

	def analysis
		@analysis = {}
		@analysis[:components] = components.map(&:analysis)
		@analysis[:conjunction] = conjunction if conjunction
		@analysis
	end
end