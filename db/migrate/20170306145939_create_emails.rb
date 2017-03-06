class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.belongs_to :organization, index: true
      t.string :content
      t.timestamps
    end
  end
end
