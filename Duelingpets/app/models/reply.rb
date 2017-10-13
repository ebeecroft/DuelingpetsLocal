class Reply < ActiveRecord::Base
   attr_accessible :message
   belongs_to :blog
   belongs_to :user

   #Validates the reply information upon submission
   validates :message, presence: true
end
