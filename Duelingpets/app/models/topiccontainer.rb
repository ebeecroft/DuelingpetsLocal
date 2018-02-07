class Topiccontainer < ActiveRecord::Base
   attr_accessible :title, :description

   #Topiccontainer related
   belongs_to :forum
   belongs_to :user
   has_many :maintopics, :foreign_key => "topiccontainer_id", :dependent => :destroy

   #Regex information for topiccontainer
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the topiccontainer information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
