class AddStateToImports < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :state, :string
  end
end
