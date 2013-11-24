class Pinimage < ActiveRecord::Base
  attr_accessible :caption, :image, :pin, :user_id
  
  has_attached_file :image, styles: { thumb: "150x150>", :convert_options => "-auto-orient"}
  
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']},
                               size: { less_than: 5.megabytes }
  
  belongs_to :pin
  belongs_to :user
end
