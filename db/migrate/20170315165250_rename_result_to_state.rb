class RenameResultToState < ActiveRecord::Migration[5.0]
  def change
    rename_column :raw_inputs, :result, :state
  end
end
