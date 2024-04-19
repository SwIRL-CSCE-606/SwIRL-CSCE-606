class AddCreatedByToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :created_by, :string
  end
end
