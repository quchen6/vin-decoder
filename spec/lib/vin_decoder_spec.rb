require 'spec_helper'

describe VinDecoder do

	let(:vin)		{ "1N4AL3AP4DC295509" }

	it "returns information using decoded vin" do
		vehicle = VinDecoder.new vin
	end
end