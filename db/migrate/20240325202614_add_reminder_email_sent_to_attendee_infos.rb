# frozen_string_literal: true

class AddReminderEmailSentToAttendeeInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :attendee_infos, :reminder_email_sent, :boolean, default: false
  end
end
