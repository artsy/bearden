class CreateAppliedTags < ActiveRecord::Migration[5.0]
  def change
    drop_table :organizations_tags

    create_table :applied_tags do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :import, index: true
      t.belongs_to :organization, index: true
      t.timestamps
    end

    create_table :imports do |t|
      t.belongs_to :source, index: true
      t.string :name
      t.string :description
      t.timestamps
    end

    change_table :sources do |t|
      t.remove :tag_id
    end
  end
end
