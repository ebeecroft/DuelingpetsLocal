class Pagesound < ActiveRecord::Base
   attr_accessible :name, :mp3, :remote_mp3_url, :mp3_cache, :ogg,
   :remote_ogg_url, :ogg_cache

   #Uploader section
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for pagesound
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
