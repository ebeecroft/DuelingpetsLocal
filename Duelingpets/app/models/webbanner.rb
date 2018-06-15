class Webbanner < ActiveRecord::Base
   attr_accessible :name, :banner, :remote_banner_url, :banner_cache

   #Uploader section
   mount_uploader :banner, BannerUploader

   #Regex information for pagesound
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
