class ChangeRecordRelationship < ActiveRecord::Migration[5.0]
  def change
  	add_column :records, :station_id, :integer
  	add_foreign_key :records, :stations
  	remove_column :records, :location_id
  end
end
