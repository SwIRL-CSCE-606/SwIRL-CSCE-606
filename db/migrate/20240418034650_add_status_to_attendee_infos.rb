class AddStatusToAttendeeInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :attendee_infos, :status, :integer, default: 1
  end
end
