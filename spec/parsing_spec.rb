require 'spec_helper'



describe 'the sentence-parsing process', type: :feature do
	before :each do 
		samples = [
			'kalama a!',
			'tenpo ni la jan Mawijo li kama lon lupa, li jo e soweli lili tu.',
			'Sili li pilin pona, li uta e jan Mawijo.',
			'ona li seli e soweli e pan.',
			'moku pona!'
		]

		parsings = [
			{has_emphatic: true},
			{context: ''},
			{},
			{},
			{}
		]
		
	end

	it 'parses phrases properly according to their grammatical role'

	end
end

