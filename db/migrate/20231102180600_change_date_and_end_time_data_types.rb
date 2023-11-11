class ChangeDateAndEndTimeDataTypes < ActiveRecord::Migration[7.0]
  def change
    change_column :event_infos, :date, :date
    change_column :event_infos, :end_time, :time
  end
end
