class AddInviteExpirationToEventInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :event_infos, :invite_expiration, :integer
  end
end
