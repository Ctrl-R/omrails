class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :loanedTo
      t.date :loanedOn
      t.date :returnedOn
      t.references :pin
      t.references :user

      t.timestamps
    end
    add_index :loans, :pin_id
    add_index :loans, :user_id
  end
end
