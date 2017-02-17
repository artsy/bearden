class DropFactualPages < ActiveRecord::Migration[5.0]
  def up
    drop_table :factual_pages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
