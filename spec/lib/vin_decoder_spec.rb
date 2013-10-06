require 'spec_helper'

describe VinDecoder do

	def do_request
		vehicle = nil
		VCR.use_cassette "vins/nissan_altima" do
			vehicle = VinDecoder.new vin, zip
		end
		vehicle
	end

	let(:vin)				{ "1N4AL3AP4DC295509" }
	let(:zip)				{ 75771 }

	it "returns information using decoded vin" do
		vehicle = do_request
		vehicle.data["makeName"].should eq "Nissan"
	end

	it "sets the new TCO" do
		vehicle = do_request
		vehicle.new_tco.should eq 27062
	end

	it "sets the used TCO" do
		vehicle = do_request
		vehicle.used_tco.should eq 25352
	end
end