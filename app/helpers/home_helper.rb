module HomeHelper

	def vehicle_details_table
		fields 		= %w(vin transmission_type engine_type engine_fuel_type 
									engine_cylinder engine_size size body_type style new_tco used_tco)
		html 			= ""

		fields.each do |field|
			html 		<< "<tr>"
			html 		<< "<td>#{Vehicle.human_attribute_name(field.to_sym)}</td>"
      html 		<< "<td>{{lastVehicle.#{field}}}</td>"
			html 		<< "</tr>"
		end
		
		raw html
	end

end
