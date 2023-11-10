class CreateTimeSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :time_slots do |t|
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false 
      t.references :event, foreign_key: true
      t.timestamps
    end
    
  end
end
