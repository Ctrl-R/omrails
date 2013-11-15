class Loan < ActiveRecord::Base
  attr_accessible :loanedon, :loanedto, :returnedon, :user_id, :pin
  
  belongs_to :pin
  belongs_to :user
  
end
