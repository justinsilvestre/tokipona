require 'spec_helper'

describe Subject do
	before :each do
		@full_clause = Clause.new %w'toki pona li toki pona'
		@compound_subject = Subject.new %w'mi mute en ona'
		@anu_subject = Subject.new %w'mi anu sina'
		@anu_en = Subject.new %w'mi en ona anu sina'
	end

	describe '#words' do
		it 'gives array of words' do
			expect(@full_clause.subject.words).to eq %w'toki pona'
		end
	end

	describe '#components' do
		it 'gives array of substantives' do
			expect(@compound_subject.components).to all(be_a Substantive)
		end
	end

	describe '#conjunctions' do
		it 'gives array of conjunctions for compound subjects with en' do
			expect(@compound_subject.conjunctions).to eq(%w'en')
		end
		it 'gives array of conjunctions for compound subjects with anu' do
			expect(@anu_subject.conjunctions).to eq(%w'anu')
		end
		it 'gives array of conjunctions for compound subjects with anu and en' do
			expect(@anu_en.conjunctions).to eq(%w'en anu')
		end
	end
end