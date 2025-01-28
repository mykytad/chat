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

ActiveRecord::Schema[7.0].define(version: 2025_01_27_150750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dialogues", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_message"
    t.boolean "pin_dialogue", default: false, null: false
    t.datetime "pined_at"
  end

  create_table "messages", force: :cascade do |t|
    t.string "body"
    t.integer "user_id", null: false
    t.integer "dialogue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "replied_to_id"
    t.boolean "read", default: false
    t.datetime "edited_at", default: "2025-01-27 15:05:52", null: false
    t.string "link_title"
    t.text "link_description"
    t.string "link_image"
    t.string "link_url"
    t.string "images"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone", default: "", null: false
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
