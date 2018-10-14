class Maintopic < ActiveRecord::Base
   attr_accessible :title, :description, :topicavatar, :remote_topicavatar_url, :topicavatar_cache

   #Maintopic related
   belongs_to :topiccontainer
   belongs_to :user
   has_many :subtopics, :foreign_key => "maintopic_id", :dependent => :destroy
   has_many :maintopicsubscribers, :foreign_key => "maintopic_id", :dependent => :destroy
   has_many :maintopicmoderatorrequests, :foreign_key => "maintopic_id", :dependent => :destroy
   has_many :maintopicmoderators, :foreign_key => "maintopic_id", :dependent => :destroy

   #Uploader section
   mount_uploader :topicavatar, TopicavatarUploader

   #Regex information for maintopic
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the maintopic information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
