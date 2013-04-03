class AddLoanSaleOptions < ActiveRecord::Migration
  def change
    add_column :pins, :forLoan, :boolean
    add_column :pins, :forSale, :boolean
  end
end
