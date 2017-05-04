class CreateOrganizationTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_types do |t|
      t.belongs_to :organization
      t.belongs_to :type
      t.timestamps
    end
  end
end
