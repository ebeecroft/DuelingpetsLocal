class Sound < ActiveRecord::Base
   attr_accessible :title, :description, :mp3, :remote_mp3_url, :mp3_cache,
   :ogg, :remote_ogg_url, :ogg_cache, :bookgroup_id

   #Sound related
   belongs_to :user
   belongs_to :subsheet
   belongs_to :bookgroup
   has_many :favoritesounds, :foreign_key => "sound_id", :dependent => :destroy
   has_many :soundstars, :foreign_key => "sound_id", :dependent => :destroy
   has_many :soundcomments, :foreign_key => "sound_id", :dependent => :destroy
   has_many :soundvisits, :foreign_key => "sound_id", :dependent => :destroy

   #Uploader section
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for sound
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
