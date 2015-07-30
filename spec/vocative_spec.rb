require 'spec_helper'

describe Vocative do

	before :each do
		@sewi = Vocative.new %W'sewi suli o'
	end

	describe '#words' do
		it "gives array of words" do
			expect(@sewi.words).to eq %W'sewi suli o'
		end
	end
end