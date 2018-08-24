class Subtopicsubscriber < ActiveRecord::Base

   #Subtopicsubscriber related
   belongs_to :user
   belongs_to :subtopic
end
