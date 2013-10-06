class VinDecoder

	BASE_URL = "https://api.edmunds.com/v1/api/toolsrepository/vindecoder"

	attr_accessor :vin, :data

	def initialize vin
		@vin 				= vin
		@data 			= decode
	end

	protected

	# Connect to the Edmunds API and retrieve the basic vehicle info
	# using the VIN
	def decode
		res 				= RestClient.get "#{BASE_URL}?vin=#{@vin}&fmt=json&api_key=#{EDMUNDS_API_KEY}"
		parsed_res 	= JSON.parse(res.body)

		# Return only the relevant data
		parsed_res["styleHolder"].try :first
	end

end