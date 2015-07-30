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

words = {
	ijo: { Translation.new :noun, ['thing', 'something', 'being'] },
	jan: { Translation.new :noun, ['person', 'human'] },
	kili: { Translation.new :noun, ['fruit', 'vegetable'] },
	lipu: { Translation.new  :noun, ['document'] },
	meli: { Translation.new :noun, ['woman', 'female'] },
	ni: { Translation.new :noun, ['this', 'that'] },
	soweli: { Translation.new :noun ['mammal', 'land animal'] }


}