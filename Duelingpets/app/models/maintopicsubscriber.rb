class Maintopicsubscriber < ActiveRecord::Base

   #Maintopicsubscriber related
   belongs_to :user
   belongs_to :maintopic
end
