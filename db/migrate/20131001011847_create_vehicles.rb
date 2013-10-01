class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.integer :year
      t.string :make
      t.string :model
      t.string :transmission_type
      t.string :engine_type
      t.string :vin

      t.timestamps
    end
  end
end
