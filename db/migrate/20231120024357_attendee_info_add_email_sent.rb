class AttendeeInfoAddEmailSent < ActiveRecord::Migration[7.0]
  def change
    add_column :attendee_infos, :email_sent, :boolean, default: false
  end
end
