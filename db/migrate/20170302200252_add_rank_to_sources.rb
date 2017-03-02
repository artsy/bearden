class AddRankToSources < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :rank, :integer
  end
end
