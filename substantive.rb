require_relative 'complement'

class Substantive
	attr_accessor :words

	def initialize(original)
		self.words = original
	end

	def simple?
		words.length == 1
	end

	def components
		# what should this return for simple substantive phrases?

	end

end