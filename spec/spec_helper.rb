require_relative '../sentence'
require 'yaml'

module Fixtures

	def prepare_sentences
		@emphatic = Sentence.new('toki pona li toki pona a!')
		@emphatic2 = Sentence.new('mi olin e sina kin.')
		@normal = Sentence.new('toki pona li toki pona.')
		@vocative = Sentence.new('sewi suli o!')
		@vocative2 = Sentence.new('jan pona o, mi olin e sina.')
		@context = Sentence.new('tenpo pini la mi lukin e suno')
		@question_tag = Sentence.new('soweli li suli anu seme?')
	end

	def prepare_clauses
		@full_clause = Clause.new %W'toki pona li toki pona' 
		@subjectless_clause = Clause.new %W'tawa pona'
		@mi_clause = Clause.new %W'mi wile moku e kili'
		@sina_clause = Clause.new %W'sina sona ala e ona'
		@mi_optative = Clause.new %W'mi o sona e ale'
	end

end