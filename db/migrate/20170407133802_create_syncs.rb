class CreateSyncs < ActiveRecord::Migration[5.0]
  def change
    create_table :syncs do |t|
      t.string :state
      t.integer :total_parts
      t.integer :uploaded_parts
      t.timestamps
    end
  end
end
