class Gallery < ActiveRecord::Base
   attr_accessible :name, :description, :ogg, :remote_ogg_url, :ogg_cache, :mp3,
   :remote_mp3_url, :mp3_cache

   #Gallery related
   has_many :mainfolders, :foreign_key => "gallery_id", :dependent => :destroy
   belongs_to :user
   has_many :galleryvisits, :foreign_key => "gallery_id", :dependent => :destroy

   #Uploader section
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for colorscheme
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the gallery information upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :description, presence: true

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
