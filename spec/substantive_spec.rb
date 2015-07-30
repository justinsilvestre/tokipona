require 'spec_helper'

describe Substantive do

	before :each do
		@many_good_people = Substantive.new %w'jan pona mute'
		@very_good_person = Substantive.new %w'jan pi pona mute'
		@person = Substantive.new %w'jan'
	end

	describe '#simple?' do
		it 'tells whether phrase is composed of a single substantive' do
			expect(@many_good_people.simple?).to be false
			expect(@person.simple?).to be true
		end
	end

	describe '#components' do
		it 'gives array of component substantives' do
			expect(@many_good_people.components).to all(be_instance_of Substantive)
		end
	end

end