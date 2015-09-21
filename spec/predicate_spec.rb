require 'spec_helper'

describe Predicate do
	include Fixtures

	before :each do
		prepare_clauses

		@anu_predicate = Predicate.new %w'li toki pona anu toki ike'
	end

	describe '#words' do
		it 'gives array of words' do
			expect(@full_clause.predicate.words).to eq %w'li toki pona'
		end
	end

	describe '#components' do
		it 'gives array of substantives' do
			expect(@compound_predicate.predicate.components).to all(be_a Substantive)
		end
	end

	describe '#particles' do
		it 'returns array for simple predicate' do
			expect(@full_clause.predicate.particles).to eq(%w'li')
		end

		it 'returns array for compound predicate' do
			expect(@compound_predicate.predicate.particles).to eq(%w'o o')
		end

		it 'returns heterogeneous array for predicate with anu' do
			expect(@anu_predicate.particles).to eq(%w'li anu')
		end
		
		it 'returns array with empty string for predicate without particles' do
			expect(@sina_clause.predicate.particles).to eq([''])
		end
	end
end