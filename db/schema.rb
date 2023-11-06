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

ActiveRecord::Schema[7.0].define(version: 2023_10_13_194658) do
  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendee_infos", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "is_attending"
    t.string "comments"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_infos", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "date"
    t.time "time"
    t.string "venue"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

=======
ActiveRecord::Schema[7.0].define(version: 2023_09_28_221446) do
>>>>>>> 264d718 (yes_no button)
  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "event_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendee_infos", "events", on_delete: :cascade
  add_foreign_key "event_infos", "events", on_delete: :cascade
  add_foreign_key "events", "event_infos"
end
