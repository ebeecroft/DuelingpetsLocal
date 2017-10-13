class Userinfo < ActiveRecord::Base
   attr_accessible :miniavatar, :remote_miniavatar_url, :miniavatar_cache, 
   :avatar, :remote_avatar_url, :avatar_cache, :browser, :vbrowser, :info, :ogg,
   :remote_ogg_url, :ogg_cache, :mp3, :remote_mp3_url, :mp3_cache, :colorscheme_id

   #Userinfo related
   belongs_to :user
   belongs_to :colorscheme

   #Uploader section
   mount_uploader :miniavatar, MiniavatarUploader
   mount_uploader :avatar, AvatarUploader
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Browser validation section
   VALID_BROWSER = /\A[a-z][a-z][a-z0-9-]+\z/i
   validates :browser, presence: true, format: {with: VALID_BROWSER}
end
