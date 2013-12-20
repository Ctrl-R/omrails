class Club < ActiveRecord::Base
  include MultiPluck
  
  serialize :userlist,Array
  serialize :pendinguser,Array
  serialize :banneduser,Array
  
  attr_accessible :admin, :description, :image, :listed, :location, :name, :userlist, :pendinguser, :banneduser
  
  has_attached_file :image, styles: { small: "120x100>", :convert_options => "-auto-orient" }
  
  validates :name, presence: true
  validates :description, presence: true
  validates :admin, presence: true
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                               size: { less_than: 5.megabytes }
  
  belongs_to :user
  has_many :users
  has_many :pins

  def self.search(search)
    if search
      find(:all, :conditions => ["(lower(description) LIKE lower(?))", "%#{search}%"])
    else
      Club.order("name")
    end
  end

end
