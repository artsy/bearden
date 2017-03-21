class AddErrorDetailsToRawInputs < ActiveRecord::Migration[5.0]
  def change
    add_column :raw_inputs, :error_details, :json
  end
end
