class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.text :description
      t.string :location
      t.boolean :listed
      t.text :userlist
      t.integer :admin
      t.attachment :image

      t.timestamps
    end
  end
end
