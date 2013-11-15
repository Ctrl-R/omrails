class ChangeColumnNamesToAllLowercase < ActiveRecord::Migration
  def change
    rename_column :loans, :loanedOn, :loanedon
    rename_column :loans, :loanedTo, :loanedto
    rename_column :loans, :returnedOn, :returnedon
    rename_column :pins, :forSale, :forsale
    rename_column :pins, :forLoan, :forloan
  end
end
