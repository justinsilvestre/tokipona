require_relative 'word_classes'
require_relative 'substantive_components'

class Substantive
	include SubstantiveComponents

	attr_reader :words
	attr_reader :parent

	def initialize(original, options={})
		@words = original

		# for tracking relationships with other words in sentences
		options.each do |key, value|
			eval("@#{key.to_s} = value")
		end
	end

	def head_and_complements
		if negative?
			@head_and_complements = [words.first] + words[2..-1]
		elsif interrogative?
			@head_and_complements = words[2..-1]
		else
			@head_and_complements = words
		end
	end

	def has_complements?
		(head_and_complements.length > 1) ? true : false
	end

	def negative?
		(words[1] == 'ala') && !interrogative?
	end

	def interrogative?
		(words.first == words[2]) && (words[1] == 'ala') 
	end

	def after_head
		return 3 if interrogative?
		return 2 if negative?
		1
	end

	def prepositional_complement_head
		head_and_complements[1..-1].find { |word| PREPOSITIONS.include? word }
	end

	def final_complement_index
		return nil unless has_complements?
		if head_and_complements.include?('pi')
			head_and_complements.index('pi')
		elsif prepositional_complement_head
			head_and_complements.index(prepositional_complement_head)
		else
			-1
		end
	end

	# fix so only initial 'pi' is rejected
	def complements
		return @complements if defined? @complements
		if has_complements?
			@complements = []
			unless final_complement_index == 1
				head_and_complements[1...final_complement_index].each { |w| add_complement [w] unless w == 'pi' }
			end
			add_complement(head_and_complements[final_complement_index..-1].reject{|w| w=='pi'})
		else
			@complements = nil
		end
	end

	def add_complement(new_words)
		@complements << new_component(new_words, parent: self)
	end

	# I'm thinking maybe it would make sense to merge together gerundive, p.o. and d.o. into 'object'
	def analysis
		@analysis = { head: words.first }
		@analysis[:interrogative] = true if interrogative?
		@analysis[:negative] = true if negative?
		@analysis[:complements] = complements.map(&:analysis) if has_complements?
		@analysis
	end
end


class Preverbal < Substantive
	def has_complements?
		false
	end

	def gerundive
		@gerundive ||= new_component words[after_head..-1]
	end

	def analysis
		super
		@analysis[:gerundive] = gerundive.analysis
		@analysis
	end
end


class Prepositional < Substantive
	def has_complements?
		false
	end

	def prepositional_object
		@prepositional_object ||= new_component words[after_head..-1]
	end

	def analysis
		super
		@analysis[:prepositional_object] = prepositional_object.analysis
		@analysis
	end
end

class Transitive < Substantive
	def head_and_complements
		super
		@head_and_complements = @head_and_complements[0...@head_and_complements.index('e')]
	end

	def direct_objects
		@direct_objects ||= words.join(' ').split(' e ')[1..-1].map do |object_string|
			new_component(object_string.split)
		end
	end

	def analysis
		super
		@analysis[:direct_objects] = direct_objects.map(&:analysis)
		@analysis
	end
end

