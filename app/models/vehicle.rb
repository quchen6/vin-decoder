class Vehicle < ActiveRecord::Base

	# validates 		:year, :model, :make, presence: true
	validate 			:validate_vin

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

	def full_name
		[year, make, model].join(" ")
	end

	protected

	def validate_vin
		if self.vin.blank?
			self.errors.add :vin, :invalid
			false
		else
			true
		end
	end
end
