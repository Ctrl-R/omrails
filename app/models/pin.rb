class Pin < ActiveRecord::Base
  
  serialize :clubs,Array
  
  attr_accessible :description, :image, :forloan, :forsale, :category, :publicgear, :clubs
  
  has_attached_file :image, styles: { medium: "320x240>", :convert_options => "-auto-orient" }
  
  validates :description, presence: true
  validates :user_id, presence: true
  validates_attachment :image, presence: true,
                               content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                               size: { less_than: 5.megabytes }
  
  belongs_to :user
  has_many :loans, dependent: :destroy
  has_many :pinimages, dependent: :destroy
  has_many :clubs
  
  def self.search(search)
    if search
      find(:all, :conditions => ["(lower(description) LIKE lower(?))", "%#{search}%"])
    else
      Pin.order("created_at desc")
    end
  end
  
end
