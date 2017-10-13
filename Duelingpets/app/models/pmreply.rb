class Pmreply < ActiveRecord::Base
   attr_accessible :message, :mp4, :remote_mp4_url, :mp4_cache, :ogv,
                   :remote_ogv_url, :ogv_cache

   #Pmreply related
   belongs_to :pm
   belongs_to :user

   #Uploader section
   mount_uploader :mp4, Mp4Uploader
   mount_uploader :ogv, OgvUploader

   #Validates the pmreply information upon submission
   validates :message, presence: true
end
