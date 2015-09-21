class Vocative
	attr_accessor :words
	def initialize(original)
		@words = original
	end

	def substantive
		@substantive ||= Substantive.new words[0..1], role: 'voc'
	end

	def indices
		substantive.indices
	end

	def tree
		@tree = substantive.tree
	end

	def index
		0
	end

	def analysis
		substantive.analyses_with_children
	end
end