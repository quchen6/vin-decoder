class AddSearchZipToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :search_zip, :integer
  end
end
