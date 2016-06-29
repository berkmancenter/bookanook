class AddGeolocationAttributesToLocation < ActiveRecord::Migration
  def up
  	add_column :locations, :latitude, :float
  	add_column :locations, :longitude, :float
  end

  def down
  	remove_column :locations, :latitude
  	remove_column :locations, :longitude
  end
end
