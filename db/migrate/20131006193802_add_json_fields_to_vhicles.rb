class AddJsonFieldsToVhicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :extra_attributes, :json
  end
end
