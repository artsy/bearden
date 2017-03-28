class AddUriToImports < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :uri, :string
  end
end
