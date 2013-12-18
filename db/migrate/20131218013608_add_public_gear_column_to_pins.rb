class AddPublicGearColumnToPins < ActiveRecord::Migration
  def change
    add_column :pins, :publicgear, :boolean
  end
end
