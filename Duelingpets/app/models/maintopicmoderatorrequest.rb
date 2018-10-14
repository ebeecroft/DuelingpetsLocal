class Maintopicmoderatorrequest < ActiveRecord::Base
   attr_accessible :message

   #Validates the maintopicmoderatorrequest information upon submission
   validates :message, presence: true

   #Maintopicmoderatorrequest related
   belongs_to :user
   belongs_to :maintopic
end
