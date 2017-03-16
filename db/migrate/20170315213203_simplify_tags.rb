class SimplifyTags < ActiveRecord::Migration[5.0]
  def change
    rename_table :imports_organizations_tags, :organization_tags
    remove_column :organization_tags, :import_id, :integer
  end
end
