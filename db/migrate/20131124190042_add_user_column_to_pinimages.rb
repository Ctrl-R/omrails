class AddUserColumnToPinimages < ActiveRecord::Migration
  def change
    add_column :pinimages, :user_id, :integer
    add_index :pinimages, :pin_id
    add_index :pinimages, :user_id
  end
end
