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

ActiveRecord::Schema.define(version: 20161104183927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_assignments_on_role_id", using: :btree
    t.index ["user_id", "role_id"], name: "index_assignments_on_user_id_and_role_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_assignments_on_user_id", using: :btree
  end

  create_table "bill_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bill_id"
    t.integer  "good_id"
    t.datetime "time_cancel"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["bill_id"], name: "index_bill_items_on_bill_id", using: :btree
    t.index ["good_id"], name: "index_bill_items_on_good_id", using: :btree
    t.index ["user_id"], name: "index_bill_items_on_user_id", using: :btree
  end

  create_table "bills", force: :cascade do |t|
    t.integer  "table_id"
    t.decimal  "total",       precision: 10, scale: 2, default: "0.0", null: false
    t.decimal  "subtotal",    precision: 10, scale: 2, default: "0.0", null: false
    t.decimal  "discount",    precision: 5,  scale: 2, default: "0.0", null: false
    t.datetime "time_cancel"
    t.datetime "time_close"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["table_id"], name: "index_bills_on_table_id", using: :btree
  end

  create_table "goods", force: :cascade do |t|
    t.string   "name",                                                null: false
    t.decimal  "price",      precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true, using: :btree
  end

  create_table "spendings", force: :cascade do |t|
    t.string   "name",                                                null: false
    t.decimal  "total",      precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "phone",                  default: "", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "assignments", "roles"
  add_foreign_key "assignments", "users"
  add_foreign_key "bill_items", "bills"
  add_foreign_key "bill_items", "goods"
  add_foreign_key "bill_items", "users"
  add_foreign_key "bills", "tables"
end
