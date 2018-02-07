class Forum < ActiveRecord::Base
   attr_accessible :name, :description, :banner, :remote_banner_url, :banner_cache, :ogg, :remote_ogg_url,
   :ogg_cache, :mp3, :remote_mp3_url, :mp3_cache, :forumtype_id, :memberprivilege_id

   #Forum related
   belongs_to :user
   belongs_to :forumtype
   belongs_to :memberprivilege
   has_many :topiccontainers, :foreign_key => "forum_id", :dependent => :destroy

   #Uploader section
   mount_uploader :banner, BannerUploader
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader

   #Regex information for name
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the forum information upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :description, presence: true

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
