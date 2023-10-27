class AddPriorityAndEmailTokenToAttendeeInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :attendee_infos, :priority, :integer
    add_column :attendee_infos, :email_token, :string
    add_index :attendee_infos, :email_token, unique: true
  end
end
