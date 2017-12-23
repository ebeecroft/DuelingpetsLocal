class Pmreply < ActiveRecord::Base
   attr_accessible :message, :mp4, :remote_mp4_url, :mp4_cache, :ogv,
                   :remote_ogv_url, :ogv_cache, :mp3, :remote_mp3_url,
                   :mp3_cache, :ogg, :remote_ogg_url, :ogg_cache,
                   :image, :remote_image_url, :image_cache

   #Pmreply related
   belongs_to :pm
   belongs_to :user

   #Uploader section
   mount_uploader :mp4, Mp4Uploader
   mount_uploader :ogv, OgvUploader
   mount_uploader :image, ImageUploader
   mount_uploader :mp3, Mp3Uploader
   mount_uploader :ogg, OggUploader

   #Validates the pmreply information upon submission
   validates :message, presence: true
end
