module SubstantiveComponents
	def new_component(original, options={})
		substantive_generator = SubstantiveGenerator.new original, self
		substantive_generator.generate
	end

	class SubstantiveGenerator
		attr_reader :words, :parent

		def initialize(original, origin)
			@words = original
			@parent = origin
		end

		def generate
			if preverbal?
				Preverbal.new words
			elsif transitive?
				Transitive.new words
			elsif prepositional?
				Prepositional.new words
			else
				Substantive.new words
			end
		end

		private

			def predicate_parent?
				defined? parent.modal_particle
			end

			def preverbal_parent?
				defined? parent.gerundive
			end

			def simple?
				words.length == 1
			end

			def preverbal?
				!simple? and predicate_parent? and (PREVERBS.include? words.first) and (words[1] != 'e' && words[1..2] != %w'ala e' && words[0...3] != [words.first, 'ala', words.first])
			end

			def transitive?
				(predicate_parent? || preverbal_parent?) and !preverbal? and words.include?('e')
			end

			def prepositional?
				!simple? and !transitive? and (PREPOSITIONS.include? words.first)
			end
	end
end