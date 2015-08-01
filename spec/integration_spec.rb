require 'spec_helper'

describe 'the sentence-parsing process', type: :feature do
	before :each do 
		@kalama = Sentence.new 'kalama a!'
		@tenpo_ni = Sentence.new 'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu.'
		@sili = Sentence.new 'Sili li pilin pona, li uta e jan Mawijo.'
		@ona_li = Sentence.new 'ona li seli e soweli e pan.'
		@moku_pona = Sentence.new 'moku pona!'
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
end


