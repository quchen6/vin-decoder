require 'spec_helper'

describe Vehicle do
  let(:vin)			{ "1N4AL3AP4DC295509" }
  let(:bad_vin)	{ "invalid_vin" }
  let(:vehicle)	{ 
		Vehicle.new(vin: vin)
	}

  describe "new_from_vin" do
		it "instantiates a new vehicle from a bin" do
			VCR.use_cassette "vins/nissan_altima" do
				vehicle.save
				vehicle.make.should eq "Nissan"
			end
		end

		it "should be valid" do
			VCR.use_cassette "vins/nissan_altima" do
				vehicle.should be_valid
			end
		end

		it "returns an error if the vin is invalid" do
			VCR.use_cassette "vins/invalid" do
				vehicle = Vehicle.new(vin: bad_vin)
				vehicle.save
				vehicle.errors.messages[:vin].should include(I18n.t("activerecord.errors.models.vehicle.attributes.vin.invalid"))
			end
		end
	end
end
