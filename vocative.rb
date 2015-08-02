class Vocative
	attr_accessor :words
	def initialize(original)
		@words = original
	end

	def substantive
		@substantive ||= Substantive.new(words[0..-1])
	end

	def analysis
		@analysis = subsantive.analysis
	end
end