class Artpage < ActiveRecord::Base
   attr_accessible :name, :message, :art, :remote_art_url,
   :art_cache

   #Uploader section
   mount_uploader :art, ArtUploader

   #Regex information for artpage
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
