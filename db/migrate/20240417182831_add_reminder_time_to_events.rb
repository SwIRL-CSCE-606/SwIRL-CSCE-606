class AddReminderTimeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :reminder_time, :datetime
  end
end
