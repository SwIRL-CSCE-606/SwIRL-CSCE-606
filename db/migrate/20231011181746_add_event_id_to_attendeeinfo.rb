class AddEventIdToAttendeeinfo < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendeeinfos, :events, null: false, foreign_key: true
  end
end
