require 'spec_helper'

describe Substantive do
	include Fixtures
	before :each do
		prepare_substantives
		prepare_clauses
	end

	describe '#simple?' do
		it 'tells whether phrase is composed of a single substantive' do
			expect(@many_good_people.simple?).to be false
			expect(@person.simple?).to be true
		end
	end

	describe '#complements' do
		it 'gives array of complements if present' do
			expect(@many_good_people.complements).to all(be_a Substantive)
			expect(@very_good_person.complements).to all(be_a Substantive)
			expect(@person.complements).to be_nil
		end
	end

	describe '#head' do
		it 'gives substantive at phrase head' do
			expect(@person.head).to eq @person
			expect(@many_good_people.head.words).to eq ['jan']
		end
	end

	describe '#antecedent' do
		it 'gives substantive being modified if current substantive is complement' do
			expect(@many_good_people.complements.first.antecedent).to be_a Substantive
		end
	end

	describe '#transitive?' do
		it 'tells whether phrase contains direct object' do
			expect(@transitive.transitive?).to be true
		end
	end

	describe '#direct_objects' do
		it 'gives array of direct objects if present' do
			expect(@compound_objects.direct_objects).to all(be_a Substantive)
		end
	end

	describe '#preverbal?' do
		it 'tells whether phrase contains preverb' do
			expect(@preverbal.preverbal?).to be true
		end
	end

	describe '#gerundive' do
		it 'gives main verb in preverbal phrase' do
			expect(@preverbal.gerundive).to be_a Substantive
		end
	end

	describe '#prepositional?' do
		it 'tells whether phrase contains preposition' do
			expect(@prepositional.prepositional?).to be true
		end
	end

	describe '#prepositional_object' do
		it 'gives object of prepositional phrase' do
			expect(@prepositional.prepositional_object.words).to eq %w'supa noka mi'
		end
	end
end