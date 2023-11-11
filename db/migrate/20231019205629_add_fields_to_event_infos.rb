class AddFieldsToEventInfos < ActiveRecord::Migration[7.0]
  def change
    rename_column :event_infos, :time, :start_time
    add_column :event_infos, :end_time, :time
    add_column :event_infos, :max_capacity, :integer
  end
end
