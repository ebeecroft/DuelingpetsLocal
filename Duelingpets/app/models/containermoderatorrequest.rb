class Containermoderatorrequest < ActiveRecord::Base
   attr_accessible :message

   #Validates the containermoderatorrequest information upon submission
   validates :message, presence: true

   #Containermoderatorrequest related
   belongs_to :user
   belongs_to :topiccontainer
end
