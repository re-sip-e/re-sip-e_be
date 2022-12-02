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

ActiveRecord::Schema.define(version: 2022_12_02_031248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bars", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.string "steps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bar_id"
    t.index ["bar_id"], name: "index_drinks_on_bar_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.bigint "drink_id"
    t.string "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drink_id"], name: "index_ingredients_on_drink_id"
  end

  add_foreign_key "drinks", "bars"
  add_foreign_key "ingredients", "drinks"
end
