class Forummoderatorrequest < ActiveRecord::Base
   attr_accessible :message

   #Validates the forummoderatorrequest information upon submission
   validates :message, presence: true

   #Forummoderatorrequest related
   belongs_to :user
   belongs_to :forum
end
