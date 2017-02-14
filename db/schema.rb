# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170213210316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applied_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "import_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["import_id"], name: "index_applied_tags_on_import_id", using: :btree
    t.index ["organization_id"], name: "index_applied_tags_on_organization_id", using: :btree
    t.index ["tag_id"], name: "index_applied_tags_on_tag_id", using: :btree
  end

  create_table "factual_pages", force: :cascade do |t|
    t.string   "table"
    t.integer  "page"
    t.json     "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["source_id"], name: "index_imports_on_source_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "locality"
    t.string   "region"
    t.string   "postcode"
    t.string   "country"
    t.decimal  "lat",             precision: 10, scale: 6
    t.decimal  "lng",             precision: 10, scale: 6
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["organization_id"], name: "index_locations_on_organization_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit",  null: false
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
