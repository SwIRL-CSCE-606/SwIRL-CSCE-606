class CreateTimeSlots < ActiveRecord::Migration[7.0]
  def change
    create_table "time_slots", force: :cascade do |t|
      t.date "date", null: false
      t.time "start_time", null: false
      t.time "end_time", null: false 
      t.integer "event_id", null: false
      t.timestamps
    end
    
    add_foreign_key "time_slots", "events", on_delete: :cascade
  end
end
