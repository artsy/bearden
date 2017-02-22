class CreateWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :websites do |t|
      t.belongs_to :organization, index: true
      t.string :content
      t.timestamps
    end

    remove_column :organizations, :website, :string
  end
end
