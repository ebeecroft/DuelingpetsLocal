class Faq < ActiveRecord::Base
   attr_accessible :title, :description, :mp3, :remote_mp3_url, :mp3_cache,
   :ogg, :remote_ogg_url, :ogg_cache

   #Uploader section
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for faq
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!?-]+\z/i

   #Validates the faq upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}, uniqueness: { case_sensitive: false}
   validates :description, presence: true

   #Overides the default parameters to use title in place of the id code
   def to_param
      title
   end
end
