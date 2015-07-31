require 'spec_helper'

describe Substantive do
	include Fixtures
	before :each do
		prepare_substantives
	end

	describe '#simple?' do
		it 'tells whether phrase is composed of a single substantive' do
			expect(@many_good_people.simple?).to be false
			expect(@person.simple?).to be true
		end
	end

	describe '#complements' do
		it 'gives array of complements if present' do
			expect(@many_good_people.complements).to all(be_instance_of Substantive)
			expect(@very_good_person.complements).to all(be_instance_of Substantive)
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
			expect(@many_good_people.complements.first.antecedent).to be_instance_of Substantive
		end
	end


end