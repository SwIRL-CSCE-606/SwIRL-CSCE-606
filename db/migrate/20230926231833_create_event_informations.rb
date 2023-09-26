class CreateEventInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :event_informations do |t|
      t.references :event, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.string :venue
      t.text :description

      t.timestamps
    end
  end
end
