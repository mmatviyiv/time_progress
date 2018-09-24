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

ActiveRecord::Schema.define(version: 2018_09_09_140545) do

  create_table "notifiers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.string "progress_type", null: false
    t.string "channel_id", null: false
    t.string "cron", null: false
    t.boolean "inactive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "channel_id", "progress_type"], name: "index_notifiers_on_team_id_and_channel_id_and_progress_type", unique: true, where: "NOT inactive"
    t.index ["team_id"], name: "index_notifiers_on_team_id"
    t.index ["user_id"], name: "index_notifiers_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slack_id", null: false
    t.boolean "uninstalled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_teams_on_slack_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "team_id"
    t.string "name"
    t.string "slack_id", null: false
    t.string "access_token", null: false
    t.boolean "revoked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "slack_id"], name: "index_users_on_team_id_and_slack_id", unique: true, where: "NOT revoked"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
