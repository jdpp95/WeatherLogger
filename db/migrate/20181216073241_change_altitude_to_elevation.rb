class ChangeAltitudeToElevation < ActiveRecord::Migration[5.0]
  def change
  	change_table :locations do |t|
  		t.rename :altitude, :elevation
  	end
  end
end
