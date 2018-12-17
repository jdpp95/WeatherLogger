class AddLocationFkToRecord < ActiveRecord::Migration[5.0]
  def change
  	add_column :records, :location_id, :integer
  	add_foreign_key :records, :locations
  end
end
