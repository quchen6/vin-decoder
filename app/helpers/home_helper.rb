module HomeHelper

	def vehicle_details_table
		fields 		= %w(vin transmission_type engine_type engine_fuel_type 
									engine_cylinder engine_size size body_type style new_tco used_tco)
		html 			= ""

		fields.each do |field|
			is_currency = field == "new_tco" || field == "used_tco"
			html 		<< "<tr>"
			html 		<< "<td>#{set_details_vehicle_text(field)}</td>"
      html 		<< "<td>{{lastVehicle.#{field} #{' | currency' if is_currency} }}</td>"
			html 		<< "</tr>"
		end
		
		raw html
	end

	def set_details_vehicle_text field
		text   		= Vehicle.human_attribute_name(field.to_sym)
		tooltip		= I18n.t("activerecord.tooltips.vehicle.#{field}", default: '')
		if tooltip.present?
			text 		= "#{text}&nbsp;<a href class='bootstrap-tooltip' data-original-title='#{tooltip}'>" + 
								"<span class='glyphicon glyphicon-info-sign'></span></a>"
		end

		text
	end

end
