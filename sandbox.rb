class Word

	def initialize()
	end

end

PARTS_OF_SPEECH = [
	:noun,
	:verb
]

class Translation
	attr_accessor :translations
	attr_accessor :part_of_speech

	def initialize(part_of_speech)
	end
end
