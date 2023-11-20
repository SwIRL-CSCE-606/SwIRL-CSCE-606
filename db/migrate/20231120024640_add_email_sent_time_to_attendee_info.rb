class AddEmailSentTimeToAttendeeInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :attendee_infos, :email_sent_time, :datetime
  end
end
