class ChangeLocationCoordinates < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :latitude, :float
    change_column :locations, :longitude, :float
  end
end
