class VinDecoder

	BASE_URL 		= "https://api.edmunds.com/v1/api"
	ENDPOINTS 	= {
		decoder: 		"/toolsrepository/vindecoder",
		new_tco: 		"/tco/newtotalcashpricebystyleidandzip",
		used_tco: 	"/tco/usedtotalcashpricebystyleidandzip",
	}

	attr_accessor :vin, :data, :new_tco, :used_tco

	def initialize vin, zip
		@vin 				= vin
		@data 			= decode
		@zip 				= zip
		@style_ids  = @data["styleIds"]
		if @style_ids.present? && @style_ids.any?
			@new_tco 		= tco "new"
			@used_tco 	= tco "used"
		end
	end

	protected

	# Connect to the Edmunds API and retrieve the basic vehicle info
	# using the VIN
	def decode
		res 				= RestClient.get decoder_endpoint
		parsed_res 	= JSON.parse(res.body)

		# Return only the relevant data
		parsed_res["styleHolder"].try :first
	end

	# Get the TCO (True Cost of Ownership) for vehicle
	def tco type
		endpoint 		= tco_enpoint(type, @style_ids.first)
		res 				= RestClient.get endpoint
		parsed_res 	= JSON.parse(res.body)

		parsed_res["value"].try :to_i
	rescue # Sometimes Edmunds cannot calculate the TCO for a vehicle
		Rails.logger.error "Failed to get #{type} TCO: #{$!.message}"

		0
	end

	# Endpoint for the vin decoder
	def decoder_endpoint
		"#{BASE_URL}#{ENDPOINTS[:decoder]}?vin=#{@vin}&fmt=json&api_key=#{EDMUNDS_API_KEY}"
	end

	# Endpoint for TCO.
	# Accepts either new or used
	def tco_enpoint type, style_id
		key 				= type == "new" ? :new_tco : :used_tco
		"#{BASE_URL}#{ENDPOINTS[key]}/#{style_id}/#{@zip}?fmt=json&api_key=#{EDMUNDS_API_KEY}"
	end

end