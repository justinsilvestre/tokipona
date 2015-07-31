require_relatiave 'word_classes'

class Substantive
	attr_reader :words
	def initialize(original, antecedent=nil)
		@words = original
		@antecedent = antecedent
	end

	def simple?
		words.length == 1
	end

	def complements
		return @complements if defined? @complements
		if simple?
			@complements = nil
		else
			@complements = []
			final_complement_index = -1 * (words.include?('pi') ? (words.length - words.index('pi')) : 1)
			words[1...final_complement_index].each do |word|
				add_complement [word]
			end
			add_complement(words[1+final_complement_index..-1])
		end
	end

	def head
		return @head if defined? @head
		if simple?
			@head = self
		else
			@head = Substantive.new [words[0]]
		end
	end

	def antecedent
		@antecedent
	end

	def add_complement(new_words)
		@complements << Substantive.new(new_words, self)
	end
end