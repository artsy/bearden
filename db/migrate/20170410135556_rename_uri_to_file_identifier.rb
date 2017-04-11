class RenameUriToFileIdentifier < ActiveRecord::Migration[5.0]
  def change
    rename_column :imports, :uri, :file_identifier
  end
end
