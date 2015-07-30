require_relative 'substantive'
class Subject
	attr_accessor :words

	def initialize(original)
		self.words = original
	end

	def conjunction
		return @conjunction if defined? @conjunction
		if words.include? 'en'
			@conjunction = 'en'
		end
	end

	def components
		return @components if defined? @components
		if !conjunction.nil?
			@components = words.join(' ').split(' en ').map do |component_string|
				Substantive.new(component_string.split)
			end
		else
			@components = [Substantive.new(words)]
		end
	end
end