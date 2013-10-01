class Vehicle < ActiveRecord::Base

	def self.new_from_vin vin
		vehicle 											= Vehicle.new

		begin
			data 												= VinDecoder.new(vin).data
			vehicle.vin 								= vin
			vehicle.year								= data["year"].to_i
			vehicle.make								= data["makeName"]
			vehicle.model								= data["modelName"]
			vehicle.transmission_type		= data["transmissionType"]
			vehicle.engine_type					= data["engineType"]

		rescue RestClient::BadRequest
			vehicle.errors.add :vin, :invalid
		end

		vehicle
	end
end
