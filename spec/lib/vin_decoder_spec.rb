require 'spec_helper'

describe VinDecoder do

	let(:vin)		{ "1N4AL3AP4DC295509" }

	it "returns information using decoded vin" do
		VCR.use_cassette "vins/nissan_altima" do
			vehicle = VinDecoder.new vin
			vehicle.data["makeName"].should eq "Nissan"
		end
	end
end