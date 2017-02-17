class CreateRawInput < ActiveRecord::Migration[5.0]
  def change
    create_table :raw_inputs do |t|
      t.belongs_to :import
      t.integer :output_id
      t.string :output_type
      t.json :data
      t.string :result
      t.timestamps
    end

    add_column :imports, :transformer, :string
  end
end
