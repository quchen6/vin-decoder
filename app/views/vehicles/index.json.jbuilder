json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, 
  json.url vehicle_url(vehicle, format: :json)
end
