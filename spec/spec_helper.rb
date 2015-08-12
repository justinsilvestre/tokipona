require_relative '../lib/parsing'

module Fixtures

	def prepare_sentences
		@emphatic = Sentence.new('toki pona li toki pona a!')
		@emphatic2 = Sentence.new('mi olin e sina kin.')
		@normal = Sentence.new('toki pona li toki pona.')
		@vocative = Sentence.new('sewi suli o!')
		@vocative2 = Sentence.new('jan pona o, mi olin e sina.')
		@context = Sentence.new('tenpo pini la mi lukin e suno')
		@question_tag = Sentence.new('soweli li suli anu seme?')
		@taso = Sentence.new('taso mi olin e ona. mi olin ala e sina.')
	end

	def prepare_clauses
		@full_clause = Clause.new %W'toki pona li toki pona' 
		@subjectless_clause = Clause.new %W'tawa pona'
		@mi_clause = Clause.new %W'mi wile moku e kili'
		@sina_clause = Clause.new %W'sina sona ala e ona'
		@mi_optative = Clause.new %W'mi o sona e ale'
		@compound_predicate = Clause.new %w'jan o pona mute o ike lili'
	end

	def prepare_substantives
		@many_good_people = Substantive.new %w'jan pona mute'
		@very_good_person = Substantive.new %w'jan pi pona mute'
		@person = Substantive.new %w'jan'
		@transitive = Transitive.new %w'moku e telo', is_predicate: true
		@compound_objects = Transitive.new %w'lukin e kasi e soweli lili', is_predicate: true
		@preverbal = Preverbal.new %w'awen lukin e kon', is_predicate: true
		@prepositional = Prepositional.new %w'lon supa noka mi'
		@simple_substantive = Substantive.new %w'pona'
	end

	def heads(strings)
		strings.map do |string|
			{ head: string }
		end
	end

end