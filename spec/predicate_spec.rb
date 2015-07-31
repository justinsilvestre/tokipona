require 'spec_helper'

describe Predicate do
	include Fixtures

	before :each do
		prepare_clauses
		@transitive = Clause.new(%w'mi moku e telo').predicates.first
		@compound_objects = Clause.new(%w'lukin e kasi e soweli lili').predicates.first
	end

	describe '#words' do
		it 'gives array of words' do
			expect(@full_clause.predicates.first.words).to eq %w'li toki pona'
		end
	end

	describe '#transitive?' do
		it 'tells whether predicate contains direct object' do
			expect(@transitive.transitive?).to be true
		end
	end

	describe '#direct_objects' do
		it 'gives array of direct objects if present' do
			expect(@compound_objects.direct_objects).to all(be_instance_of Substantive)
		end
	end

end