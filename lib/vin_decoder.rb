class VinDecoder

	BASE_URL = "https://api.edmunds.com/v1/api/toolsrepository/vindecoder"

	def initialize vin
		@vin 				= vin

		decode
	end

	protected

	def decode
		res 				= RestClient.get "#{BASE_URL}?vin=#{@vin}&fmt=json&api_key=#{EDMUNDS_API_KEY}"
		parsed_res 	= JSON.parse(res.body)

		parsed_res["styleHolder"].try :first
	end

end