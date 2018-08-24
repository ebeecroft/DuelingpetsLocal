class Movie < ActiveRecord::Base
   attr_accessible :title, :description, :mp4, :remote_mp4_url, :mp4_cache, :ogv,
                   :remote_ogv_url, :ogv_cache, :bookgroup_id

   #Movie related
   belongs_to :user
   belongs_to :subplaylist
   belongs_to :bookgroup
   has_many :favoritemovies, :foreign_key => "movie_id", :dependent => :destroy
   has_many :moviestars, :foreign_key => "movie_id", :dependent => :destroy
   has_many :moviecomments, :foreign_key => "movie_id", :dependent => :destroy
   has_many :movievisits, :foreign_key => "movie_id", :dependent => :destroy

   #Uploader section
   mount_uploader :mp4, Mp4Uploader
   mount_uploader :ogv, OgvUploader

   #Regex information for colorscheme
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validation section
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
