class AddClubsColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clubs, :text
  end
end
