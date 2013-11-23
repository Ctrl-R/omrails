class CreatePinimages < ActiveRecord::Migration
  def change
    create_table :pinimages do |t|
      t.attachment :image
      t.string :caption
      t.references :pin

      t.timestamps
    end
  end
end
