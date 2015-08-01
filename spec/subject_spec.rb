require 'spec_helper'

describe Subject do
	before :each do
		@full_clause = Clause.new %w'toki pona li toki pona'
		@compound_subject = Subject.new %w'mi mute en ona'
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

end