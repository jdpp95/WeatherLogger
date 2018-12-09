class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :department
      t.string :country
      t.float :latitude
      t.float :longitude
      t.integer :altitude

      t.timestamps
    end
  end
end
