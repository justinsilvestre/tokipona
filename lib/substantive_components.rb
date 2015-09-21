module SubstantiveComponents
	def new_component(original, options={})
		substantive_generator = SubstantiveGenerator.new original, options
		substantive_generator.generate
	end

	class SubstantiveGenerator
		attr_reader :words, :parent

		def initialize(original, options={})
			@words = original
			@options = default_options.merge(options)
		end

		def default_options
			{ index_start: 0 }
		end

		def generate
			if preverbal?
				Preverbal.new words, @options
			elsif transitive?
				Transitive.new words, @options
			elsif prepositional?
				Prepositional.new words, @options
			else
				Substantive.new words, @options
			end
		end

		private

			def words_ignoring_head_polarity
				return [words.first] + words[2..-1] if negative_head?
				return words[2..-1] if interrogative_head?
				words
			end

			def negative_head?
				(words[1] == 'ala') && !interrogative_head?
			end

			def interrogative_head?
				words[0...3] == [words.first, 'ala', words.first]
			end

			def predicate_parent?
				@options[:role] == 'pred'
			end

			def preverbal_parent?
				@options[:role] == 'geru'
			end

			def simple?
				words_ignoring_head_polarity.length == 1
			end

			def preverbal?
				!simple? and predicate_parent? and (PREVERBS.include? words.first) and !(%w'e anu'.include? words_ignoring_head_polarity[1])
			end

			def transitive?
				(predicate_parent? || preverbal_parent?) and !preverbal? and words.include?('e')
			end

			def prepositional?
				!simple? and !transitive? and (PREPOSITIONS.include? words.first) and (words_ignoring_head_polarity[1] != 'anu')
			end
	end
end