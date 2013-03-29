class Loan < ActiveRecord::Base
  attr_accessible :loanedOn, :loanedTo, :returnedOn
  
  belongs_to :pin
  belongs_to :user
end
