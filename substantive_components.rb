module SubstantiveComponents
	def new_component(original, options={})
		substantive_generator = SubstantiveGenerator.new original, options
		substantive_generator.generate
	end

	class SubstantiveGenerator
		attr_reader :words, :options, :is_predicate

		def initialize(original, original_options)
			@words = original
			@options = original_options
			options.each do |key, value|
				eval("@#{key.to_s} = value")
			end
		end

		def generate
			if preverbal?
				Preverbal.new words, options
			elsif transitive?
				Transitive.new words, options
			elsif prepositional?
				Prepositional.new words, options
			else
				Substantive.new words, options
			end
		end

		private

			def simple?
				words.length == 1
			end

			def preverbal?
				!simple? and is_predicate and (PREVERBS.include? words.first) and words[1] != 'e'
			end

			def transitive?
				is_predicate and !preverbal? and words.include?('e')
			end

			def prepositional?
				!simple? and !transitive? and (PREPOSITIONS.include? words.first)
			end
	end
end