class AddColumnToPins < ActiveRecord::Migration
  def change
    add_column :pins, :loan, :references
  end
end
