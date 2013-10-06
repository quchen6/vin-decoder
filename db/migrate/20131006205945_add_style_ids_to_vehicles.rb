class AddStyleIdsToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :style_ids, :integer, array: true, default: []
  end
end
