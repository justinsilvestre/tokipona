require_relative 'word_classes'
require_relative 'substantive_components'
require_relative 'indexable'

class Substantive
	include SubstantiveComponents
	include Indexable

	attr_reader :words
	attr_reader :index_start
	attr_reader :part_of_speech, :role

	def initialize(original, options={})
		@words = original

		# for tracking relationships with other words in sentences
		default_options.merge(options).each do |key, value|
			eval("@#{key.to_s} = value")
		end
	end

	def default_options
		{ index_start: 0 }
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
				head_and_complements[1...final_complement_index].each_with_index do |w, i|
					add_complement([w], i) unless w == 'pi'
				end
			end
			add_complement(head_and_complements[final_complement_index..-1].reject{|w| w=='pi'}, @complements.length)
		else
			@complements = nil
		end
	end

	def complement_index_start(complement_index)
		total = index_start
		@components.each do |component|
 			total += component.indices - 1
		end
		total
	end

	def add_complement(new_words, i)
		new_index = index_start
		if i == 0
			new_index +=  1
		else
			@complements.each do |complement|
				new_index += complement.indices
			end
		end
		@complements << new_component(new_words, index_start: new_index, role: 'comp', pos: 'i')
	end

	# I'm thinking maybe it would make sense to merge together gerundive, p.o. and d.o. into 'object'
	def tree
		@tree = { head: words.first }
		@tree[:interrogative] = true if interrogative?
		@tree[:negative] = true if negative?
		@tree[:complements] = complements.map(&:tree) if has_complements?
		@tree
	end

	def pos
		@part_of_speech = 'pro' if words.first == words.first.capitalize
		@part_of_speech = 't' if defined? direct_objects
		@part_of_speech = 'prev' if defined? gerundive
		@part_of_speech = 'prep'if defined? prepositional_object
		@part_of_speech ||= 'i'
	end

	def children
		complements
	end

	def analysis
		@analysis = { word: words.first, pos: pos, role: role }
		@analysis[:interrogative] = true if interrogative?
		@analysis[:negative] = true if negative?
		@analysis[:complements] = complements.map(&:index) if has_complements?
		@analysis[:parent] = parent.index if parent
		@analysis
	end

	def index
		index_start
	end

	def indices
		return 1 if !children
		total = 1
		children.each do |child|
			total += child.indices
		end
		total
	end
end


class Preverbal < Substantive
	def has_complements?
		false
	end

	def gerundive
		@gerundive ||= new_component(words[after_head..-1], index_start: index + 1, role: 'geru')
	end

	def children
		[ gerundive ]
	end

	def tree
		super
		@tree[:gerundive] = gerundive.tree
		@tree
	end
end


class Prepositional < Substantive
	def has_complements?
		false
	end

	def prepositional_object
		@prepositional_object ||= new_component(words[after_head..-1], index_start: index + 1, role: 'prob', pos: 'i')
	end

	def children
		[ prepositional_object ]
	end

	def tree
		super
		@tree[:prepositional_object] = prepositional_object.tree
		@tree
	end
end

class Transitive < Substantive
	def head_and_complements
		super
		@head_and_complements = @head_and_complements[0...@head_and_complements.index('e')]
	end

	def direct_objects
		@direct_objects = []
		direct_object_strings = words.join(' ').split(' e ')[1..-1]
		direct_object_strings.each do |object_string|
			add_direct_object object_string.split, new_direct_object_index
		end
		@direct_objects
	end

	def add_direct_object(words, index)
		@direct_objects << new_component(words,
			index_start: index, role: 'drob', pos: 'i')
	end

	def new_direct_object_index
		complement_indices = has_complements? ? all_indices(complements) : 0
		d_o_indices = @direct_objects ? all_indices(@direct_objects) : 0
		index_start + 1 + complement_indices + d_o_indices
	end

	def children
		return direct_objects unless has_complements?
		direct_objects + complements
	end

	def tree
		super
		@tree[:direct_objects] = direct_objects.map(&:tree)
		@tree
	end
end

