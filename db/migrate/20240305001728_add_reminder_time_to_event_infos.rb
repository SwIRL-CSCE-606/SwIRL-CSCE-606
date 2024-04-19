# frozen_string_literal: true

class AddReminderTimeToEventInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :event_infos, :reminder_time, :timestamptz
  end
end
