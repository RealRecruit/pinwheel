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

ActiveRecord::Schema[8.1].define(version: 2026_09_22_151817) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_assignments_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_assignments_on_project_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "creator_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_comments_on_creator_id"
    t.index ["project_id"], name: "index_comments_on_project_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "platform", null: false
    t.string "token", null: false
    t.string "name"
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_devices_on_token", unique: true
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "user_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "creator_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "archived_at"], name: "index_projects_on_account_id_and_archived_at"
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["creator_id"], name: "index_projects_on_creator_id"
  end

  create_table "push_deliveries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "device_id", null: false
    t.string "title", null: false
    t.text "body"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_push_deliveries_on_device_id"
    t.index ["user_id"], name: "index_push_deliveries_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "assignments", "projects"
  add_foreign_key "assignments", "users"
  add_foreign_key "comments", "projects"
  add_foreign_key "comments", "users", column: "creator_id"
  add_foreign_key "devices", "users"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "projects", "accounts"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "push_deliveries", "devices"
  add_foreign_key "push_deliveries", "users"
  add_foreign_key "sessions", "users"
end
