# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_03_193426) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "match_achievements", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "tournament_achievement_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_achievements_on_match_id"
    t.index ["tournament_achievement_id"], name: "index_match_achievements_on_tournament_achievement_id"
    t.index ["user_id"], name: "index_match_achievements_on_user_id"
  end

  create_table "match_results", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "match_id", null: false
    t.integer "tournament_id", null: false
    t.integer "score"
    t.integer "eliminations"
    t.integer "commander_damage"
    t.integer "final_life"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["match_id"], name: "index_match_results_on_match_id"
    t.index ["tournament_id"], name: "index_match_results_on_tournament_id"
    t.index ["user_id"], name: "index_match_results_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "winner_id"
    t.datetime "played_at"
    t.integer "duration"
    t.integer "round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id"
    t.index ["created_by_id"], name: "index_matches_on_created_by_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tournament_achievements", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "points", null: false
    t.boolean "unique_completion", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_achievements_on_tournament_id"
  end

  create_table "tournament_organizers", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_organizers_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_organizers_on_user_id"
  end

  create_table "tournament_participants", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "user_id", null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["tournament_id", "user_id"], name: "index_tournament_participants_on_tournament_id_and_user_id", unique: true
    t.index ["tournament_id"], name: "index_tournament_participants_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_participants_on_user_id"
  end

  create_table "tournament_scorings", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.integer "position", null: false
    t.integer "points", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_scorings_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.integer "number_of_rounds"
    t.integer "max_players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.string "invite_code"
    t.string "slug", null: false
    t.index ["invite_code"], name: "index_tournaments_on_invite_code", unique: true
    t.index ["owner_id"], name: "index_tournaments_on_owner_id"
    t.index ["slug"], name: "index_tournaments_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "match_achievements", "matches"
  add_foreign_key "match_achievements", "tournament_achievements"
  add_foreign_key "match_achievements", "users"
  add_foreign_key "match_results", "matches"
  add_foreign_key "match_results", "tournaments"
  add_foreign_key "match_results", "users"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "matches", "users", column: "created_by_id"
  add_foreign_key "matches", "users", column: "winner_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "tournament_achievements", "tournaments"
  add_foreign_key "tournament_organizers", "tournaments"
  add_foreign_key "tournament_organizers", "users"
  add_foreign_key "tournament_participants", "tournaments"
  add_foreign_key "tournament_participants", "users"
  add_foreign_key "tournament_scorings", "tournaments"
  add_foreign_key "tournaments", "users", column: "owner_id"
end
