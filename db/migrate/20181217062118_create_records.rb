class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
    	t.datetime :time
      t.float :temperature
      t.integer :humidity
      t.string :conditions
      t.integer :icon, null: true
      t.integer :cloud_cover, null: true
      t.timestamps
    end
  end
end
