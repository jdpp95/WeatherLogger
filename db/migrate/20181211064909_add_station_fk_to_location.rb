class AddStationFkToLocation < ActiveRecord::Migration[5.0]
  def change
  	add_column :locations, :station_id, :integer
  	add_foreign_key :locations, :stations
  end
end
