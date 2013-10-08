class Vehicle < ActiveRecord::Base

	DEFAULT_ZIP 					= 75771

	before_validation 		:set_default_zip
	validates 						:vin, presence: true
	after_validation 			:get_info_from_edmunds, unless: Proc.new{ |x| x.errors.any? }

	attr_accessor 				:zip

	def full_name
		[year, make, model, trim].join(" ")
	end

	def full_error_messages
		self.errors.full_messages
	end

	protected

	def get_info_from_edmunds
		vehicle = self

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
		rescue
			vehicle.errors.add :base, :unknown
		end
	end

	def validate_vin
		if self.vin.blank?
			self.errors.add :vin, :invalid
			false
		else
			true
		end
	end

	def set_default_zip
		self.zip = DEFAULT_ZIP if self.zip.blank?
	end
end
