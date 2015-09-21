require 'spec_helper'

describe 'Indexable' do

	before do
		@olin = Sentence.new 'mi olin e sina'
		@mi_en = Sentence.new 'mi en sina mute li pona mute a'
		@siblings = Sentence.new 'ona li pona li suli'
		@very_good = Substantive.new %w'jan pi pona mute'
		@many_good = Substantive.new %w'jan pona mute'
		@compound_subject = Sentence.new 'mi mute en sina mute en ona mute li jan pona mute'
		@comp_sen = Sentence.new 'mi jo e kili lili'
		@tenpo_ni_la = Sentence.new 'tenpo ni la mi kama sona e mije'
		@jan_ali_o = Sentence.new 'jan ali o, o kama!'
	end
	
	it 'gives indices for Substantive with complements' do
		expect(@very_good.indices).to eq(3)
	end

	it 'gives indices for Substantive with modified complement' do
		expect(@many_good.indices).to eq(3)
	end

	it 'gives indices for simple sentence' do
		expect(@olin.clause.indices).to eq(3)
	end

	it 'gives indices for simple subject' do
		expect(@olin.subject.indices).to eq (1)
	end

	it 'gives indices for compound subject' do
		expect(@mi_en.subject.indices).to eq (3)
	end

	it 'gives indices for simple predicate' do
		expect(@olin.predicate.indices).to eq (2)
	end

	it 'gives indices for direct object' do
		expect(@olin.predicate[0].direct_objects.first.indices).to eq(1)
	end

	it 'gives correct index for subject head' do
		expect(@olin.subject.components.first.index).to eq(0)
	end

	it 'gives correct index for predicate head' do
		expect(@olin.predicate.components.first.index).to eq(1)
	end

	it 'gives index for predicate with prior siblings' do
		expect(@siblings.predicate[1].index).to eq(2)
	end

	it 'gives index for subject with prior siblings' do
		expect(@compound_subject.subject.components[2].index).to eq(4)
	end

	it 'gives correct index for complements' do
		expect(@mi_en.subject[1].complements[0].index).to eq(2)
	end

	it 'gives correct index for direct object' do
		expect(@comp_sen.predicate[0].direct_objects[0].index).to eq(2)
	end

	it 'gives correct index for direct object with prior siblings' do
		expect(Sentence.new('mi olin e sina e ona e ali').predicate[0].direct_objects[2].index).to eq(4)
		expect(Sentence.new('mi olin mute e ona e ali').predicate[0].direct_objects[1].index).to eq(4)
	end

	it 'gives correct index for direct objects of modified verb' do
		expect(Sentence.new('mi olin mute e sina').predicate[0].direct_objects[0].index).to eq(3)
	end

	it 'gives correct index for direct object with prior modified siblings' do
		expect(Sentence.new('mi olin mute e kili suli e telo').predicate[0].direct_objects[1].index).to eq(5)
	end

	it 'gives correct index for gerundives' do
		expect(Sentence.new('mi wile unpa').predicate[0].gerundive.index).to eq(2)
	end

	it 'gives correct index for prepositional objects' do
		expect(Sentence.new('mi lon ali').predicate[0].prepositional_object.index).to eq(2)
	end

	it 'gives correct index after context' do
		expect(@tenpo_ni_la.subject[0].index).to eq(2)
		expect(@tenpo_ni_la.predicate[0].index).to eq(3)
	end

	it 'gives correct index after vocative' do
		expect(@jan_ali_o.predicate[0].index).to eq(2)
	end
end