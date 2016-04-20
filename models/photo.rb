require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

class ImageUploader < CarrierWave::Uploader::Base
  storage :file
end

class Photo < ActiveRecord::Base
  has_many :comments
  has_many :likes
  belongs_to :user
  mount_uploader :img_url, ImageUploader
end
