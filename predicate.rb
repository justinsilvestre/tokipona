class Predicate
	attr_reader :words
	attr_reader :clause

	def initialize(original, clause)
		@words = original
		@clause = clause
	end

	def transitive?
		words.include? 'e'
	end

	def direct_objects
		return @direct_objects if defined? @direct_objects
		if transitive?
			@direct_objects = words.join(' ').split(' e ')[1..-1].map do |object_string|
				Substantive.new(object_string.split)
			end
		else
			@direct_objects = nil
		end
	end


end