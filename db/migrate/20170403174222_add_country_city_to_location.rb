class AddCountryCityToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :country, :string
    add_column :locations, :city, :string
  end
end
