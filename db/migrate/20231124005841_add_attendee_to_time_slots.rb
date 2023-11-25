class AddAttendeeToTimeSlots < ActiveRecord::Migration[7.0]
  def change
    add_column :time_slots, :attendee_id, :integer, default: nil
    add_foreign_key :time_slots, :attendee_infos, column: :attendee_id
  end
end
