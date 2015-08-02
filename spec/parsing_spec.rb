require 'spec_helper'

describe Parsing do
	before :each do
		@kalama_sili = Parsing.new 'kalama a! tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu. Sili li pilin pona, li uta e jan Mawijo. ona li seli e soweli e pan. suno li lon kon, taso mi wile e ni: tenpo pimeja. moku pona!'
	end

	describe '#sentences' do
		it 'gives array of sentences' do
			expect(@kalama_sili.sentences).to all(be_instance_of Sentence)
			expect(@kalama_sili.sentences.map { |s| s.original_text }).to eq [
				'kalama a!',
				'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu.',
				'Sili li pilin pona, li uta e jan Mawijo.',
				'ona li seli e soweli e pan.',
				'suno li lon kon,',
				'taso mi wile e ni:',
				'tenpo pimeja.',
				'moku pona!'
			] 
		end
	end

end