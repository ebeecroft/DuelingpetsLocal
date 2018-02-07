class Narrative < ActiveRecord::Base
   attr_accessible :story, :ogg, :remote_ogg_url, :ogg_cache,
   :mp3, :remote_mp3_url, :mp3_cache, :forumgroup_id

   #Narrative related
   belongs_to :subtopic
   belongs_to :user
   belongs_to :forumgroup

   #Uploader section
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Validates the narrative information upon submission
   validates :story, presence: true
end
