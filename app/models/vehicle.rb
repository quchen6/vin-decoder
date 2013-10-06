class Vehicle < ActiveRecord::Base

	# validates 		:year, :model, :make, presence: true
	validate 				:validate_vin

	attr_accessor 	:zip

	def self.new_from_vin vin, zip
		vehicle 											= Vehicle.new

		begin
			decoder 										= VinDecoder.new(vin, zip)
			data 												= decoder.data
			vehicle.vin 								= vin
			vehicle.zip 								= zip
			vehicle.year								= data["year"].try :to_i
			vehicle.make								= data["makeName"].try :titleize
			vehicle.model								= data["modelName"].try :titleize
			vehicle.transmission_type		= data["transmissionType"].try :titleize
			vehicle.engine_type					= data["engineType"].try :titleize
			vehicle.engine_fuel_type		= data["engineFuelType"].try :titleize
			vehicle.engine_cylinder 		= data["engineCylinder"].try :to_i
			vehicle.engine_size	 				= data["engineSize"].try :to_f
			vehicle.trim	 							= data["trim"]["name"]
			vehicle.size	 							= data["categories"]["Vehicle Size"].try :first
			vehicle.body_type	 					= data["categories"]["PRIMARY_BODY_TYPE"].try :first
			vehicle.style	 							= data["categories"]["Vehicle Style"].try :first
			vehicle.extra_attributes	 	= data["attributeGroups"]
			vehicle.style_ids 					= data["styleIds"]
			vehicle.new_tco 						= decoder.new_tco
			vehicle.used_tco 						= decoder.used_tco
		rescue RestClient::BadRequest
			vehicle.errors.add :vin, :invalid
		end

		vehicle
	end

	def full_name
		[year, make, model, trim].join(" ")
	end

	def full_error_messages
		self.errors.full_messages
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
