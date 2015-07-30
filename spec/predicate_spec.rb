require 'spec_helper'

describe Predicate do
	include Fixtures

	before :each do
		prepare_clauses
	end

	describe '#words' do
		it 'gives array of words' do
			expect(@full_clause.predicate.words).to eq %w'li toki pona'
		end
	end

end