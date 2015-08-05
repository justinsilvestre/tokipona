require 'spec_helper'

describe Substantive do
	include Fixtures
	before :each do
		prepare_substantives
		prepare_clauses
	end

	describe '#complements' do
		it 'gives array of complements if present' do
			expect(@many_good_people.complements).to all(be_a Substantive)
			expect(@very_good_person.complements).to all(be_a Substantive)
			expect(@person.complements).to be_nil
		end
	end

	describe '#direct_objects' do
		it 'gives array of direct objects if present' do
			expect(@compound_objects.direct_objects).to all(be_a Substantive)
		end
	end

	describe '#gerundive' do
		it 'gives main verb in preverbal phrase' do
			expect(@preverbal.gerundive).to be_a Substantive
		end
	end

	describe '#prepositional_object' do
		it 'gives object of prepositional phrase' do
			expect(@prepositional.prepositional_object.words).to eq %w'supa noka mi'
		end
	end

end