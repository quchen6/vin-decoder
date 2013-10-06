class AddTcoToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :used_tco, :integer
    add_column :vehicles, :new_tco, :integer
  end
end
