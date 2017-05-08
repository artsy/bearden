class AddOrganizationTypeRankToSources < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :organization_type_rank, :integer
  end
end
