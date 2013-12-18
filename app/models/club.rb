class Club < ActiveRecord::Base
  include MultiPluck
  
  serialize :userlist,Array
  serialize :pendinguser,Array
  serialize :banneduser,Array
  
  attr_accessible :admin, :description, :image, :listed, :location, :name, :userlist, :pendinguser, :banneduser
  
  has_attached_file :image, styles: { medium: "320x240>", :convert_options => "-auto-orient" }
  
  validates :name, presence: true
  validates :description, presence: true
  validates :admin, presence: true
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                               size: { less_than: 5.megabytes }
  
  belongs_to :user
  has_many :users
  has_many :pins
    
end
