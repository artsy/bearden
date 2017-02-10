class CreateTagsSourcesOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :website
      t.timestamps
    end

    create_table :locations do |t|
      t.belongs_to :organization, index: true
      t.string :address1
      t.string :address2
      t.string :locality
      t.string :region
      t.string :postcode
      t.string :country
      t.decimal :lat, { :precision => 10, :scale => 6 }
      t.decimal :lng, { :precision => 10, :scale => 6 }
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :sources do |t|
      t.belongs_to :tag, index: true
      t.string :name
      t.timestamps
    end

    create_table :organizations_tags, id: false do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :tag, index: true
    end

  end
end
