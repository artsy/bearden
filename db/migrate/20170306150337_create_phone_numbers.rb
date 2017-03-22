class CreatePhoneNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_numbers do |t|
      t.belongs_to :organization, index: true
      t.string :content
      t.timestamps
    end
  end
end
