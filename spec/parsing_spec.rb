require 'spec_helper'

describe Parsing do
	before :each do
		@kalama_sili = Parsing.new 'kalama a!!! tenpo $ni la @jan Mawijo li ka>>ma lon lupa, li jo e soweli lili tu, li lukin e jan Mawijo. Sili li pilin pona, li uta e jan Mawijo. ona li seli e soweli e pan. suno li lon kon, taso mi wile e ni: tenpo pimeja. moku pona!'
		@tp = Parsing.new 'toki pona li toki pona'
		@tptp = Parsing.new 'toki pona li toki pona, taso pona toki li sama ala toki pona'
	end

	describe '#sentences' do
		it 'gives array of sentences' do
			expect(@kalama_sili.sentences).to all(be_instance_of Sentence)
			expect(@kalama_sili.sentences.map { |s| s.original_text }).to eq [
				'kalama a!!!',
				'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu, li lukin e jan Mawijo.',
				'Sili li pilin pona, li uta e jan Mawijo.',
				'ona li seli e soweli e pan.',
				'suno li lon kon,',
				'taso mi wile e ni:',
				'tenpo pimeja.',
				'moku pona!'
			] 
		end
	end

	describe '#sentences' do
		it 'parses sentences regardless of punctuation' do
			expect(@tp.sentences[0].words).to eq %w'toki pona li toki pona'
		end
	end

	describe '#sentences' do
		it 'parses sentences regardless of irregular punctuation' do
			expect(@tptp.sentences.map(&:words)).to eq [
				%w'toki pona li toki pona',
				%w'taso pona toki li sama ala toki pona'
			]
		end
	end
end