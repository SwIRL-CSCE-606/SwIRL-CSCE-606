class ChangeEventInfoEndTimeToDateTime < ActiveRecord::Migration[7.0]
  def change
    change_column :event_infos, :end_time, :datetime
  end
end
