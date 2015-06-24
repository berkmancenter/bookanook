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

ActiveRecord::Schema.define(version: 20150429195304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "amenities",    default: [],              array: true
    t.json     "attrs"
    t.json     "hidden_attrs"
    t.json     "hours"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "nooks", force: :cascade do |t|
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.text     "place"
    t.string   "photos",                 default: [],              array: true
    t.json     "hours"
    t.integer  "min_capacity"
    t.integer  "max_capacity"
    t.integer  "min_schedulable"
    t.integer  "max_schedulable"
    t.integer  "min_reservation_length"
    t.integer  "max_reservation_length"
    t.string   "amenities",              default: [],              array: true
    t.json     "attrs"
    t.json     "hidden_attrs"
    t.text     "use_policy"
    t.boolean  "bookable"
    t.boolean  "requires_approval"
    t.boolean  "repeatable"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "nooks", ["location_id"], name: "index_nooks_on_location_id", using: :btree
  add_index "nooks", ["user_id"], name: "index_nooks_on_user_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "nook_id"
    t.integer  "user_id"
    t.boolean  "public"
    t.string   "status"
    t.integer  "priority"
    t.datetime "start"
    t.datetime "end"
    t.text     "description"
    t.text     "notes"
    t.string   "repeats_every"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "reservations", ["nook_id"], name: "index_reservations_on_nook_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "nooks", "locations"
  add_foreign_key "nooks", "users"
  add_foreign_key "reservations", "nooks"
  add_foreign_key "reservations", "users"
end
