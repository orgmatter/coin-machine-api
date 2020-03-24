# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_23_165903) do

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "admin_type"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coins", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "count_status"
    t.index ["user_id"], name: "index_coins_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type"
    t.decimal "value"
    t.integer "user_id", null: false
    t.integer "coin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coin_id"], name: "index_transactions_on_coin_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "api_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "roles"
    t.integer "admin_id"
    t.index ["admin_id"], name: "index_users_on_admin_id"
  end

  add_foreign_key "coins", "users"
  add_foreign_key "transactions", "coins"
  add_foreign_key "transactions", "users"
  add_foreign_key "users", "admins"
end
