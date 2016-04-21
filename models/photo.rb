require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => 'ap-southeast-2',
    :host   => 's3-ap-southeast-2.amazonaws.com'
  }

  config.storage = :fog
  config.fog_directory    = ENV['S3_BUCKET']
end

# imageuploader to store files
class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  # storage :file
end

class Photo < ActiveRecord::Base
  has_many :comments
  has_many :likes
  belongs_to :user
  mount_uploader :img_url, ImageUploader
  # img_url is the column name in db
  # ImageUploader is the filename
end
