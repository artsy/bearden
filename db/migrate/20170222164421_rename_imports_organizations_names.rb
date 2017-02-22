class RenameImportsOrganizationsNames < ActiveRecord::Migration[5.0]
  def change
    rename_table :imports_organizations_names, :organization_names
    remove_column :organization_names, :name_id, :integer
    remove_column :organization_names, :import_id, :integer
    add_column :organization_names, :content, :string
    drop_table :names
  end
end
