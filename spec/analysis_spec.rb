require 'spec_helper'

describe 'analysis', type: :feature do
	before do
		@olin = Sentence.new('mi olin e sina').analysis
		@tenpo_ni = Sentence.new('ona li pona la mi olin e ona').analysis
		@wile = Sentence.new('mi wile lon ma pona').analysis
		@lon = Sentence.new('ona li lon ma pona').analysis
		@mute = Sentence.new('mi mute mute li pona mute').analysis
		@sewi = Sentence.new('tan ma tomo Pape la, sewi Jawe li tawa e jan tawa ma mute').analysis
	end

	it "analyzes complements of direct objects" do
		expect(@sewi[:substantives][6]).to eq(
			word: 'tawa',
			pos: 't',
			role: 'pred',
			objects: [7],
			particle: 'li'
		)
	end

	it "analyzes a subject head" do
		expect(@olin[:substantives][0]).to eq(
			role: 'subj',
			word: 'mi',
			pos: 'i'
		)
	end

	it "analyzes a predicate head" do
		expect(@olin[:substantives][1]).to eq(
			role: 'pred',
			word: 'olin',
			pos: 't',
			objects: [2]
		)
	end

	it "analyzes a context subject head" do
		expect(@tenpo_ni[:substantives][0]).to eq(
			role: 'csub',
			word: 'ona',
			pos: 'i'
		)
	end

	it "analyzes a context predicate head" do
		expect(@tenpo_ni[:substantives][1]).to eq(
			role: 'cpre',
			word: 'pona',
			pos: 'i',
			particle: 'li'
		)
	end

	it "analyzes a transitive phrase" do
		expect(@olin[:substantives][1]).to eq(
			word: 'olin',
			role: 'pred',
			pos: 't',
			objects: [2]
		)
	end

	it "analyzes a direct object" do
		expect(@olin[:substantives][2]).to eq(
			role: 'drob',
			word: 'sina',
			pos: 'i',
			parent: 1
		)
	end

	it "analyzes a preverbal" do
		expect(@wile[:substantives][1]).to eq(
			role: 'pred',
			word: 'wile',
			pos: 'prev',
		)
	end

	it "analyzes a prepositional phrase" do
		expect(@lon[:substantives][1]).to eq(
			role: 'pred',
			word: 'lon',
			pos: 'prep',
			particle: 'li'
		)
	end

	it "analyzes a modified substantive" do
		expect(@mute[:substantives][0]).to eq(
			role: 'subj',
			word: 'mi',
			pos: 'i',
			complements: [1,2]
		)
	end

	it "analyzes a complement" do
		mute_analysis = {
			role: 'comp',
			word: 'mute',
			pos: 'i',
			parent: 0
		}
		expect(@mute[:substantives][1]).to eq(mute_analysis)
		expect(@mute[:substantives][2]).to eq(mute_analysis)
	end
end