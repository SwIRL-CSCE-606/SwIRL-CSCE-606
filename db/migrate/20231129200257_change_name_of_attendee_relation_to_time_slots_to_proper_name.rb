class ChangeNameOfAttendeeRelationToTimeSlotsToProperName < ActiveRecord::Migration[7.0]
  def change
    rename_column :time_slots, :attendee_id, :attendee_info_id
  end
end
