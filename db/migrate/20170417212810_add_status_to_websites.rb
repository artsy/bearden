class AddStatusToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :status, :integer
  end
end
