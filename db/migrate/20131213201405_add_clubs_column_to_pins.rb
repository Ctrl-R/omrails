class AddClubsColumnToPins < ActiveRecord::Migration
  def change
    add_column :pins, :clubs, :text
  end
end
