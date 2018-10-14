class Art < ActiveRecord::Base
   attr_accessible :title, :description, :image, :remote_image_url, :image_cache,
   :mp3, :remote_mp3_url, :mp3_cache, :ogg, :remote_ogg_url, :ogg_cache,
   :bookgroup_id

   #Art related
   belongs_to :user
   belongs_to :subfolder
   belongs_to :bookgroup
   has_many :favoritearts, :foreign_key => "art_id", :dependent => :destroy
   has_many :artstars, :foreign_key => "art_id", :dependent => :destroy
   has_many :artcomments, :foreign_key => "art_id", :dependent => :destroy
   has_many :artvisits, :foreign_key => "art_id", :dependent => :destroy

   #Uploader section
   mount_uploader :image, ImageUploader
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for art
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
