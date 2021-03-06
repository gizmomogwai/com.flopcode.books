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

ActiveRecord::Schema.define(version: 20160326094031) do

  create_table "active_checkouts", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "checkout_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "active_checkouts", ["book_id"], name: "index_active_checkouts_on_book_id"
  add_index "active_checkouts", ["checkout_id"], name: "index_active_checkouts_on_checkout_id"

  create_table "api_keys", force: :cascade do |t|
    t.string   "key"
    t.string   "for_app"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id"

  create_table "books", force: :cascade do |t|
    t.string   "isbn"
    t.string   "title"
    t.string   "authors"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  add_index "books", ["user_id"], name: "index_books_on_user_id"

  create_table "checkouts", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "checkouts", ["book_id"], name: "index_checkouts_on_book_id"
  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id"

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "admin"
  end

end
