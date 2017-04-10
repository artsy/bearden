class AddCsvToImports < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :csv, :string
    remove_column :imports, :uri
  end
end
