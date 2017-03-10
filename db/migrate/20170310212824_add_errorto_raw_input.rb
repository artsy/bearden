class AddErrortoRawInput < ActiveRecord::Migration[5.0]
  def change
    add_column :raw_inputs, :error, :string
  end
end
