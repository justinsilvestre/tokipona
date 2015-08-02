require 'spec_helper'

describe 'the sentence-analyzing process', type: :feature do
	include Fixtures

	before :each do 
		@kalama = Sentence.new 'kalama a!'
		@tenpo_ni = Sentence.new 'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu.'
		@sili = Sentence.new 'Sili li pilin pona, li uta e jan Mawijo.'
		@ona_li = Sentence.new 'ona li seli e soweli e pan.'
		@moku_pona = Sentence.new 'moku pona!'
		prepare_substantives
	end

	it 'parses context, subject and predicate' do
		expect(@kalama.subject).to be_nil
		expect(@kalama.predicate.words).to eq %w'kalama'
		expect(@tenpo_ni.context.words).to eq %w'tenpo ni la'
		expect(@tenpo_ni.subject.words).to eq %w'jan Mawijo'
		expect(@tenpo_ni.predicate.words).to eq %w'li kama lon lupa li jo e soweli lili tu'
	end


	it 'parses each individual predicate in sentence with compound predicate' do
		expect(@sili.predicate.components.first.words).to eq %w'pilin pona'
		expect(@sili.predicate.components.last.words).to eq %w'uta e jan Mawijo'
	end

	it 'parses a substantive phrase with simple complements' do
		expect(@many_good_people.complements.map(&:words)).to eq [['pona'], ['mute']]
	end

	it 'parses a substantive with compound complements' do
		expect(@very_good_person.complements.map(&:words)).to eq [%w'pona mute']
	end

	it 'parses a substantive phrase with simple and compound complements' do
		expect(@very_good_big_person.complements.map(&:words)).to eq [['suli'],%w'pona mute']
	end

	it 'parses a simple predicate' do
		expect(@kalama.predicate.analysis).to eq %w'kalama'
	end

	it 'parses a transitive predicate' do
		expect(@ona_li.predicate.analysis).to eq([{ head: 'seli', direct_objects: %w'soweli pan' }])
	end

	it 'parses a compound predicate' do
		expect(@tenpo_ni.predicate.analysis).to eq [
			{ head: 'kama', gerundive: {head: 'lon', prepositional_object: 'lupa'} },
			{ head: 'jo', direct_objects: [{ head: 'soweli', complements: %w'lili tu' }] }
		]
	end

	it 'parses a simple subject' do
		expect(@sili.subject.analysis).to eq(components: ['Sili'])
	end

	it 'parses a subject with complements' do
		expect(@tenpo_ni.subject.analysis).to eq(components: [{head: 'jan', complements: ['Mawijo']}])
	end

	it 'parses a whole sentence' do
		expect(@ona_li.analysis).to eq(
			subject: { components: ["ona"] },
			predicate: [{ head: "seli", direct_objects: ["soweli", "pan"]}],
			end_punctuation: ".",
			mood: :indicative
		)
	end
end

