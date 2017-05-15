class SwitchToStringForInBusiness < ActiveRecord::Migration[5.0]
  def up
    change_column :organizations, :in_business, :string, default: nil
  end

  def down
    remove_column :organizations, :in_business
    add_column :organizations, :in_business, :boolean, default: true
  end
end
