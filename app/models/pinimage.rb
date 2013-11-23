class Pinimage < ActiveRecord::Base
  attr_accessible :caption, :image, :pin
  
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']},
                               size: { less_than: 5.megabytes }
  
  belongs_to :pin
  has_attached_file :image, styles: { thumb: "150x150>"}
end
