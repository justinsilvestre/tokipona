require 'spec_helper'

describe 'the sentence-analyzing process', type: :feature do
	include Fixtures

	before :each do 
		@kalama = Sentence.new 'kalama a!'
		@tenpo_ni = Sentence.new 'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu.'
		@sili = Sentence.new 'Sili li pilin pona, li uta e jan Mawijo.'
		@ona_li = Sentence.new 'ona li seli e soweli e pan.'
		@moku_pona = Sentence.new 'moku pona!'
		@snake = Sentence.new 'akesi li toki tawa sina la o pana ala kin e wile pi pona tawa akesi ni.'
		@triple_predicate = Sentence.new 'soweli lili li pona mute tawa mi li kiwen ala li olin e mama ona'
		@nimi = Sentence.new 'o nimi pi mi mute li kama suli!'
		@negative = Sentence.new 'mi wile ala e ni.'
		@kenla = Sentence.new 'ken la jan li ken moku e ona e ona weka telo kin.'
		prepare_substantives
	end

	it 'parses context, subject and predicate' do
		expect(@kalama.subject).to be_nil
		expect(@kalama.predicate.words).to eq %w'kalama'
		expect(@tenpo_ni.context.words).to eq %w'tenpo ni la'
		expect(@tenpo_ni.subject.words).to eq %w'jan Mawijo'
		expect(@tenpo_ni.predicate.words).to eq %w'li kama lon lupa li jo e soweli lili tu'
	end

	it 'parses a context with subject and predicate' do
		expect(@snake.context.subject.components.first.words).to eq %w'akesi'
		expect(@snake.context.predicate.components.first.words).to eq %w'toki tawa sina'
	end

	it 'parses a null subject' do
		expect(@nimi.subject).to be_nil
	end

	it 'analyzes context with subject' do
		expect(@snake.analysis[:context]).to eq(
			subject: { components: [{head: 'akesi'}] },
			predicate: [{
				head: 'toki',
				complements: [{
					head:'tawa',
					prepositional_object: {head:'sina'}
				}]
			}]
		)
	end
	it 'analyzes complex predicate' do
		expect(@snake.analysis[:predicate]).to eq [{
			head: 'pana',
			negative: true,
			complements: heads(%w'kin'),
			direct_objects: [{
				head: 'wile',
				complements: [{
					head: 'pona',
					complements: [{
						head:'tawa',
						prepositional_object: {
							head: 'akesi',
							complements: [{ head:'ni' }]
						}
					}]
				}]
			}]
		}]
	end


	it 'parses each individual predicate in sentence with compound predicate' do
		expect(@sili.predicate.components.first.words).to eq %w'pilin pona'
		expect(@sili.predicate.components.last.words).to eq %w'uta e jan Mawijo'
		expect(@triple_predicate.predicate.components.map(&:words)).to eq [
			%w'pona mute tawa mi',
			%w'kiwen ala',
			%w'olin e mama ona'
		]
	end

	it 'parses a negative substantive without extra complements' do
		expect(@negative.predicate.components.length).to eq 1
		expect(@negative.predicate.components[0].complements).to be_nil
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
		expect(@kalama.predicate.analysis).to eq [{ head: 'kalama' }]
	end

	it 'parses a transitive predicate' do
		expect(@ona_li.predicate.analysis).to eq([{
			head: 'seli',
			direct_objects: heads(%w'soweli pan')
		}])
	end

	it 'parses a transitive gerundive' do
		expect(@kenla.predicate.components.first.gerundive.has_complements?).to eq false
	end

	it 'parses a compound predicate' do
		expect(@tenpo_ni.predicate.analysis).to eq [
			{ head: 'kama', gerundive: { head: 'lon', prepositional_object: {head:'lupa'} } },
			{ head: 'jo', direct_objects: [{ head: 'soweli', complements: heads(%w'lili tu') }] }
		]
	end

	it 'parses a simple subject' do
		expect(@sili.subject.analysis).to eq(components: [{head:'Sili'}])
	end

	it 'parses a subject with complements' do
		expect(@tenpo_ni.subject.analysis).to eq(components: [{head: 'jan', complements: heads(%w'Mawijo')}])
	end

	it 'parses a whole sentence' do
		expect(@ona_li.analysis).to eq(
			subject: { components: [{head:"ona"}] },
			predicate: [{ head: "seli", direct_objects: heads(%w'soweli pan') }],
			end_punctuation: ".",
			mood: :indicative
		)
	end
end


