# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160714221431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "name"
    t.integer  "pincode"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "supplier_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "addresses", ["supplier_id"], name: "index_addresses_on_supplier_id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.string   "short_description"
    t.text     "description"
    t.string   "location"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "contact_us", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "website"
    t.string   "fax"
    t.string   "skype"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "contacts", ["supplier_id"], name: "index_contacts_on_supplier_id", using: :btree

  create_table "finances", force: :cascade do |t|
    t.string   "price_list"
    t.string   "currency"
    t.string   "tax_code"
    t.string   "email"
    t.string   "registration_number"
    t.string   "payment_method"
    t.integer  "credit_limit"
    t.integer  "credit_lead_time"
    t.string   "bank_name"
    t.integer  "account_number"
    t.string   "IFSC_code"
    t.integer  "supplier_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "finances", ["supplier_id"], name: "index_finances_on_supplier_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "pincode"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "field_type"
    t.boolean  "require"
    t.integer  "subcategory_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "product_fields", ["subcategory_id"], name: "index_product_fields_on_subcategory_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "skuid"
    t.string   "brand"
    t.string   "permalink"
    t.text     "description"
    t.text     "short_description"
    t.boolean  "active",                                    default: true
    t.integer  "quantity",                                  default: 0
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_price",        precision: 8, scale: 2, default: 0.0
    t.boolean  "stock_control",                             default: true
    t.integer  "subcategory_id"
    t.integer  "parent_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "properties"
    t.integer  "supplier_id"
    t.integer  "tax_rate_id"
    t.integer  "brand_id"
    t.integer  "size_id"
    t.string   "images",                                    default: [],                array: true
    t.string   "image_name"
    t.string   "image_id"
    t.json     "cloudinary_images"
    t.integer  "user_id"
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["parent_id"], name: "index_products_on_parent_id", using: :btree
  add_index "products", ["size_id"], name: "index_products_on_size_id", using: :btree
  add_index "products", ["subcategory_id"], name: "index_products_on_subcategory_id", using: :btree
  add_index "products", ["supplier_id"], name: "index_products_on_supplier_id", using: :btree
  add_index "products", ["tax_rate_id"], name: "index_products_on_tax_rate_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "rides", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "amenities"
    t.decimal  "number_of_workstations"
    t.decimal  "hourly_rental"
    t.decimal  "morning_rental"
    t.decimal  "evening_rental"
    t.decimal  "daily_rental"
    t.decimal  "weekly_rental"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "pincode"
    t.string   "landmark"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.json     "images"
    t.integer  "user_id"
  end

  add_index "rides", ["category_id"], name: "index_rides_on_category_id", using: :btree
  add_index "rides", ["subcategory_id"], name: "index_rides_on_subcategory_id", using: :btree
  add_index "rides", ["user_id"], name: "index_rides_on_user_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "morning_ride"
    t.boolean  "evening_ride"
    t.boolean  "all_day"
    t.integer  "ride_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "schedules", ["ride_id"], name: "index_schedules_on_ride_id", using: :btree

  create_table "sizes", force: :cascade do |t|
    t.string   "name"
    t.decimal  "volume"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_levels", force: :cascade do |t|
    t.date     "date"
    t.integer  "adjustment"
    t.string   "description"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "stock_levels", ["product_id"], name: "index_stock_levels_on_product_id", using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "subcategories", ["category_id"], name: "index_subcategories_on_category_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "company"
    t.string   "code"
    t.string   "status"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tax_rates", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.decimal  "rate",        precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "addresses", "suppliers"
  add_foreign_key "contacts", "suppliers"
  add_foreign_key "finances", "suppliers"
  add_foreign_key "product_fields", "subcategories"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "sizes"
  add_foreign_key "products", "subcategories"
  add_foreign_key "products", "suppliers"
  add_foreign_key "products", "tax_rates"
  add_foreign_key "products", "users"
  add_foreign_key "rides", "categories"
  add_foreign_key "rides", "subcategories"
  add_foreign_key "rides", "users"
  add_foreign_key "schedules", "rides"
  add_foreign_key "stock_levels", "products"
  add_foreign_key "subcategories", "categories"
end
