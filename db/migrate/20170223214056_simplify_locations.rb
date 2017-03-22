class SimplifyLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :content, :string
    remove_column :locations, :address1, :string
    remove_column :locations, :address2, :string
    remove_column :locations, :locality, :string
    remove_column :locations, :region, :string
    remove_column :locations, :postcode, :string
    remove_column :locations, :country, :string

    rename_column :locations, :lat, :latitude
    rename_column :locations, :lng, :longitude
  end
end
