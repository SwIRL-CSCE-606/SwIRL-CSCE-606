class SingularEvent < ActiveRecord::Migration[7.0]
  def change
    create_table 'singular_event' do |t|
      t.string 'name'
      t.string 'date'
      t.text 'description'
      t.string 'comments'
      # Add fields that let Rails automatically keep track
      # of when singular_events are added or modified:
      t.timestamps
    end
  end
end



