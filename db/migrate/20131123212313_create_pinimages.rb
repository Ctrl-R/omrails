class CreatePinimages < ActiveRecord::Migration
  def change
    create_table :pinimages do |t|
      t.attachment :image
      t.string :caption
      t.integer :user_id
      t.references :pin
      t.references :user

      t.timestamps
    end
    add_index :pinimages, :pin_id
    add_index :pinimages, :user_id
  end
end
