require 'open-uri'

class Pin < ActiveRecord::Base
  attr_accessible :description, :image, :image_remote_url
 

  validates :description, presence: true
	validates :user_id, presence: true
	validates_attachment :image, presence: true,
												content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']},
												size: { less_than: 5.megabytes }

  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_attached_file :image, styles: { medium: "320x240>"}
  has_reputation :votes, source: :user, aggregated_by: :sum

  #has_reputaion :votes, source: :user, aggregated_by: :sum
  # remote image uploading


  def image_remote_url=(url_value)
    self.image = URI.parse(url_value) unless url_value.blank?
    super
  end


end
