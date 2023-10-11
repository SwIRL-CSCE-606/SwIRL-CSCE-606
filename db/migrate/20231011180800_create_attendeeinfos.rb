class CreateAttendeeinfos < ActiveRecord::Migration[7.0]
  def change
    create_table :attendeeinfos do |t|
      t.string :name
      t.string :email
      t.string :isattending
      t.string :comments
    end
  end
end
