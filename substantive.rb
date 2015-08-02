require_relative 'word_classes'

class Substantive
	attr_reader :words
	attr_reader :antecedent
	def initialize(original, options={})
		@words = original

		# for tracking relationships with other words in sentences
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
			@gerundive = Substantive.new words[1..-1]
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
		@without_direct_object = !transitive? ? words : words[0..words.index('e')-1]
	end

	def has_complements?
		true if !preverbal? && !prepositional? && (without_direct_object.length > 1)
	end

	def final_complement_index
		return nil unless has_complements?
		if without_direct_object.include?('pi')
			-1 * (without_direct_object.length - without_direct_object.index('pi'))
		else
			without_direct_object.length - 1
		end
	end

	# must fix this so it recognizes prepositional phrase as single complement
	def complements
		return @complements if defined? @complements
		if has_complements?
			@complements = []
			words[1...final_complement_index].each do |word|
				add_complement [word]
			end
			add_complement(without_direct_object[final_complement_index..-1].reject{|w| w=='pi'})
		else
			@complements = nil
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
		@complements << Substantive.new(new_words, antecedent: self.head)
	end

	def transitive?
		!preverbal? and words.include?('e')
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

	# I'm thinking maybe it would make sense to merge together gerundive, p.o. and d.o. into 'object'
	def analysis
		return (@analysis = words.first) if simple?
		@analysis = { head: head.analysis }
		@analysis[:complements] = complements.map(&:analysis) if has_complements?
		if preverbal?
			@analysis[:gerundive] = gerundive.analysis
		elsif prepositional?
			@analysis[:prepositional_object] = prepositional_object.analysis
		elsif transitive?
			@analysis[:direct_objects] = direct_objects.map(&:analysis)
		end
		@analysis
	end
end