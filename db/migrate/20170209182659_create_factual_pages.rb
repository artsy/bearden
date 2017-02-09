class CreateFactualPages < ActiveRecord::Migration[5.0]
  def change
    create_table :factual_pages do |t|
      t.string :table
      t.integer :page
      t.json :payload
      t.timestamps
    end
  end
end
