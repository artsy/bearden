class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.string :email
      t.timestamps
    end

    create_table :addresses do |t|
      t.belongs_to :company, index: true
      t.string :address
      t.string :locality
      t.string :postcode
      t.string :region
      t.string :country
      t.string :phone
      t.string :hours
      t.decimal :lat, { :precision => 10, :scale => 6 }
      t.decimal :lng, { :precision => 10, :scale => 6 }
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :companies_tags, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :tag, index: true
    end

  end
end
