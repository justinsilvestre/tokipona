require_relative 'word_classes'

class Substantive
	attr_reader :words
	attr_reader :antecedent
	def initialize(original, options={})
		@words = original

		options.each do |key, value|
			eval("@#{key.to_s} = value")
		end
	end

	def simple?
		words.length == 1
	end

	def preverbal?
		!simple? and (PREVERBS.include? words.first) and words[1] != 'e'
	end

	def gerundive
		return @gerundive if defined? @gerundive
		if preverbal?
			@gerundive = Substantive.new [words.first]
		else
			@gerundive = nil
		end
	end

	def prepositional?
		!simple? and !transitive? and (PREPOSITIONS.include? words.first)
	end

	def prepositional_object
		return @prepositional_object if defined? @prepositional_object
		if prepositional?
			@prepositional_object = Substantive.new words[1..-1]
		else
			@prepositional_object = nil
		end
	end

	def without_direct_object
		return @without_direct_object if defined? @without_direct_object
		@without_direct_object = !transitive? ? words : words[0..-1*words.reverse.index('e')]
	end

	def has_complements?
		true if !preverbal? && without_direct_object.length > 1
	end

	# must fix this so it recognizes prepositional phrase as single complement
	def complements
		return @complements if defined? @complements
		if has_complements?
			@complements = []
			final_complement_index = -1 * (words.include?('pi') ? (words.length - words.index('pi')) : 1)
			words[1...final_complement_index].each do |word|
				add_complement [word]
			end
			add_complement(without_direct_object[1+final_complement_index..-1])
		else
			nil
		end
	end

	def head
		return @head if defined? @head
		if simple?
			@head = self
		else
			@head = Substantive.new [words.first]
		end
	end

	def add_complement(new_words)
		@complements << Substantive.new(new_words, antecedent: self)
	end

	def transitive?
		words.include?('e') and !preverbal?
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