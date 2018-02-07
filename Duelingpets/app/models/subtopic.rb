class Subtopic < ActiveRecord::Base
   attr_accessible :title, :description, :topicavatar, :remote_topicavatar_url,
   :topicavatar_cache, :forumgroup_id

   #Subtopic related
   belongs_to :maintopic
   belongs_to :user
   belongs_to :forumgroup
   has_many :narratives, :foreign_key => "subtopic_id", :dependent => :destroy

   #Uploader section
   mount_uploader :topicavatar, TopicavatarUploader

   #Regex information for subtopic
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the subtopic information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
