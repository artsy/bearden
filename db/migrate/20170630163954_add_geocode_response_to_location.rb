class AddGeocodeResponseToLocation < ActiveRecord::Migration[5.1]
  def up
    add_column :locations, :geocode_response, :json
  end

  def down
    remove_column :locations, :geocode_response
  end
end
