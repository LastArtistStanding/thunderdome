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

ActiveRecord::Schema.define(version: 2019_08_10_210227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.string "topic"
    t.string "duration"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "submissions"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "match_id"
    t.integer "score"
    t.float "elo_delta"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "elo"
    t.string "name"
    t.index ["match_id"], name: "index_participants_on_match_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.float "elo"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "multi_wins"
    t.integer "multi_losses"
    t.integer "multi_ties"
  end

  add_foreign_key "participants", "matches"
  add_foreign_key "participants", "users"
end
