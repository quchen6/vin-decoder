class AddDetailFieldsToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :engine_fuel_type, :string
    add_column :vehicles, :engine_cylinder, :integer
    add_column :vehicles, :engine_size, :float
    add_column :vehicles, :trim, :string
    add_column :vehicles, :size, :string
    add_column :vehicles, :body_type, :string
    add_column :vehicles, :style, :string
  end
end
