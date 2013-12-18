class AddPendingAndBannedUserColumnsToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :pendinguser, :text
    add_column :clubs, :banneduser, :text
  end
end
