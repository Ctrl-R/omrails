class AddCategoryColumnToPins < ActiveRecord::Migration
  def change
    add_column :pins, :category, :string
  end
end
