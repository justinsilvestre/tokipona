require_relative 'substantive_components'
require_relative 'word_classes'
require_relative 'indexable'

class Substantive
	include SubstantiveComponents
	include Indexable

	attr_reader :words
	attr_reader :index_start, :parent, :particle
	attr_reader :pos, :role

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

	def add_complement(new_words, i)
		@complements << new_component(new_words,
			index_start: new_complement_index, role: 'comp', pos: 'i', parent: self)
	end

	def new_complement_index
		1 + index_start + @complements.inject(0) { |t, c| t + c.indices }
	end

	# I'm thinking maybe it would make sense to merge together gerundive, p.o. and d.o. into 'object'
	def tree
		@tree = { head: words.first }
		@tree[:interrogative] = true if interrogative?
		@tree[:negative] = true if negative?
		@tree[:complements] = complements.map(&:tree) if has_complements?
		@tree
	end

	def children
		complements
	end

	def analysis
		@analysis = { word: words.first, pos: pos, role: role }
		@analysis[:particle] = particle if particle
		@analysis[:interrogative] = true if interrogative?
		@analysis[:negative] = true if negative?
		@analysis[:complements] = complements.map(&:index) if has_complements?
		@analysis[:parent] = parent.index if parent
		@analysis
	end

	def complement_analyses
		has_complements? ? complements.map(&:analysis) : []
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

	def analyses_with_children
		return [analysis] unless children
		[analysis] + children.inject([]) do |analyses, child|
			analyses + child.analyses_with_children
		end
	end
end

require_relative 'substantive_prepositional'
require_relative 'substantive_preverbal'
require_relative 'substantive_transitive'
