class Radiostation < ActiveRecord::Base
   attr_accessible :name, :description, :ogv, :remote_ogv_url, :ogv_cache, :mp4,
   :remote_mp4_url, :mp4_cache

   #Radiostation related
   has_many :mainsheets, :foreign_key => "radiostation_id", :dependent => :destroy
   belongs_to :user
   has_many :radiostationvisits, :foreign_key => "radiostation_id", :dependent => :destroy

   #Uploader section
   mount_uploader :ogv, OgvUploader
   mount_uploader :mp4, Mp4Uploader

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
