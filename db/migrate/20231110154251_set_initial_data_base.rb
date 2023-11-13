class SetInitialDataBase < ActiveRecord::Migration[7.0]
  def change
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
      t.integer "priority"
      t.string "email_token"
      t.index ["email_token"], name: "index_attendee_infos_on_email_token", unique: true
    end

    create_table "event_infos", force: :cascade do |t|
      t.string "name"
      t.string "description"
      t.date "date"
      t.time "start_time"
      t.string "venue"
      t.integer "event_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.time "end_time"
      t.integer "max_capacity"
    end

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
end
