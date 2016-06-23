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

ActiveRecord::Schema.define(version: 20160621004355) do

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "open_schedule_id"
    t.text     "attrs"
    t.text     "hidden_attrs"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "locations", ["open_schedule_id"], name: "index_locations_on_open_schedule_id", using: :btree

  create_table "nooks", force: :cascade do |t|
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.text     "place"
    t.string   "photos",                 default: [],              array: true
    t.integer  "open_schedule_id"
    t.integer  "min_capacity"
    t.integer  "max_capacity"
    t.integer  "min_schedulable"
    t.integer  "max_schedulable"
    t.integer  "min_reservation_length"
    t.integer  "max_reservation_length"
    t.text     "attrs"
    t.text     "hidden_attrs"
    t.text     "use_policy"
    t.boolean  "bookable"
    t.boolean  "requires_approval"
    t.boolean  "repeatable"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "cancel_before"
  end

  add_index "nooks", ["location_id"], name: "index_nooks_on_location_id", using: :btree
  add_index "nooks", ["open_schedule_id"], name: "index_nooks_on_open_schedule_id", using: :btree

  create_table "open_schedules", force: :cascade do |t|
    t.string   "name"
    t.integer  "seconds_per_block",              null: false
    t.integer  "blocks_per_span"
    t.string   "span_name"
    t.boolean  "blocks",            default: [],              array: true
    t.integer  "duration",                       null: false
    t.datetime "start",                          null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "nook_id"
    t.integer  "user_id"
    t.boolean  "public"
    t.string   "name"
    t.string   "url"
    t.string   "stream_url"
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

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "authid"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "locations", "open_schedules"
  add_foreign_key "nooks", "locations"
  add_foreign_key "nooks", "open_schedules"
  add_foreign_key "reservations", "nooks"
  add_foreign_key "reservations", "users"
end
