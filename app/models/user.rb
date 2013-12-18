class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  serialize :favorites,Array
  serialize :clubs,Array

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :favorites, :admin, :clubs
  # attr_accessible :title, :body
  
  has_many :pins, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :clubs
end
