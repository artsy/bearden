class CreateNames < ActiveRecord::Migration[5.0]
  def change
    rename_table :applied_tags, :imports_organizations_tags

    change_table :organizations do |t|
      t.remove :name
    end

    create_table :names do |t|
      t.string :content
      t.timestamps
    end

    create_table :imports_organizations_names do |t|
      t.belongs_to :name, index: true
      t.belongs_to :import, index: true
      t.belongs_to :organization, index: true
      t.timestamps
    end
  end
end
