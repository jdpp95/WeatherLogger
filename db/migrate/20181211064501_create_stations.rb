class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.string :place
      t.float :latitude
      t.float :longitude
      t.float :elevation

      t.timestamps
    end
  end
end
