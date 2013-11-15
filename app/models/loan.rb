class Loan < ActiveRecord::Base
  attr_accessible :loanedOn, :loanedTo, :returnedOn, :user_id, :pin
  
  belongs_to :pin
  belongs_to :user
  
end
