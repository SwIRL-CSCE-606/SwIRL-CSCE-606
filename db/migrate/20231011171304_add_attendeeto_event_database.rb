class AddAttendeetoEventDatabase < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :totalattendee, :string
  end
end
