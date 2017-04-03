class AddMoreRankColumnsToSources < ActiveRecord::Migration[5.0]
  def change
    remove_column :sources, :rank, :integer
    add_column :sources, :email_rank, :integer
    add_column :sources, :location_rank, :integer
    add_column :sources, :organization_name_rank, :integer
    add_column :sources, :phone_number_rank, :integer
    add_column :sources, :website_rank, :integer
  end
end
