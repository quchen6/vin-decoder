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
		# Can't test with an exact number because Edmunds' values always change.
		# If a cassette gets rerecorded, then the value potentially changes.
		vehicle.new_tco.should > 0
	end

	it "sets the used TCO" do
		vehicle = do_request
		# See comment on new tco spec
		vehicle.used_tco.should > 0
	end
end