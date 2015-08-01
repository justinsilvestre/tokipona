require 'spec_helper'

describe Clause do
	include Fixtures

	before :each do
		prepare_clauses
	end

	describe '#words' do
		it "gives array of words" do
			expect(@full_clause.words).to eq %W'toki pona li toki pona'
		end
	end

	describe '#subject' do
		it 'points to subject of clause if subject is present' do
			expect(@full_clause.subject).to be_instance_of Subject
			expect(@subjectless_clause.subject).to be_nil
			expect(@mi_clause.subject).to be_instance_of Subject
		end
	end

	describe '#predicate' do
		it 'points to predicate of clause' do
			expect(@full_clause.predicate).to be_instance_of Predicate
		end
	end
end