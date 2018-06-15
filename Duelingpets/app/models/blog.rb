class Blog < ActiveRecord::Base
   attr_accessible :title, :description, :adbanner, :remote_adbanner_url, :adbanner_cache, 
   :admascot, :remote_admascot_url, :admascot_cache, :largeimage1, :remote_largeimage1_url,
   :largeimage1_cache, :largeimage2, :remote_largeimage2_url, :largeimage2_cache,
   :largeimage3, :remote_largeimage3_url, :largeimage3_cache, :smallimage1,
   :remote_smallimage1_url, :smallimage1_cache, :smallimage2, :remote_smallimage2_url,
   :smallimage2_cache, :smallimage3, :remote_smallimage3_url, :smallimage3_cache,
   :smallimage4, :remote_smallimage4_url, :smallimage4_cache, :smallimage5,
   :remote_smallimage5_url, :smallimage5_cache

   #Blogs related
   has_many :replies, :foreign_key => "blog_id", :dependent => :destroy
   has_many :blogstars, :foreign_key => "blog_id", :dependent => :destroy
   has_many :blogvisits, :foreign_key => "blog_id", :dependent => :destroy
   belongs_to :user

   #Uploader section
   mount_uploader :adbanner, AdbannerUploader
   mount_uploader :admascot, AdmascotUploader
   mount_uploader :largeimage1, Largeimage1Uploader
   mount_uploader :largeimage2, Largeimage2Uploader
   mount_uploader :largeimage3, Largeimage3Uploader
   mount_uploader :smallimage1, Smallimage1Uploader
   mount_uploader :smallimage2, Smallimage2Uploader
   mount_uploader :smallimage3, Smallimage3Uploader
   mount_uploader :smallimage4, Smallimage4Uploader
   mount_uploader :smallimage5, Smallimage5Uploader

   #Regex for title
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the blog information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
