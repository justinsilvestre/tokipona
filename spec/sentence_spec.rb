require 'spec_helper'

describe Sentence do
	include Fixtures

	before :each do
		prepare_sentences
	end

	describe '#without_emphatic' do
		it "gives sentence without emphatic particle" do
			expect(@emphatic.without_emphatic).to eq %W'toki pona li toki pona'
			expect(@emphatic2.without_emphatic).to eq %W'mi olin e sina'
			expect(@normal.without_emphatic).to eq @normal.words
		end
	end

	describe '#vocative' do
		it 'points to Vocative object if sentence has vocative' do
			expect(@vocative.vocative).to be_instance_of Vocative
		end
	end

	describe '#without_vocative_or_emphatic' do
		it "gives sentence without vocative expression or emphatic particle" do
			expect(@vocative2.without_vocative_or_emphatic).to eq %W'mi olin e sina'
		end
	end

	describe "#context" do
		it 'points to Context object if sentence has context' do
			expect(@context.context).to be_instance_of Context
		end
	end

	describe "#clause" do
		it "points to Clause object if sentence has clause" do
			expect(@context.clause).to be_instance_of Clause
			expect(@vocative.clause).to be_nil
		end
	end

	describe '#question_tag' do
		it 'gives question tag if present in sentence' do
			expect(@question_tag.question_tag).to eq %w'anu seme'
		end
	end
end