class AddInBusinessToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :in_business, :boolean, default: true
  end
end
