require 'spec_helper'

describe Vehicle do
  let(:vin)			{ "1N4AL3AP4DC295509" }
  let(:bad_vin)	{ "invalid_vin" }
  let(:vehicle)	{ 
		VCR.use_cassette "vins/nissan_altima" do
			Vehicle.new_from_vin vin
		end
	}

  describe "new_from_vin" do
		it "instantiates a new vehicle from a bin" do
			vehicle.make.should eq "Nissan"
		end

		it "should be valid" do
			vehicle.should be_valid
		end

		it "returns an error if the vin is invalid" do
			VCR.use_cassette "vins/invalid" do
				vehicle = Vehicle.new_from_vin bad_vin
				vehicle.errors.messages[:vin].should include(I18n.t("activerecord.errors.models.vehicle.attributes.vin.invalid"))
			end
		end
	end
end
