class Containersubscriber < ActiveRecord::Base

   #Containersubscriber related
   belongs_to :user
   belongs_to :topiccontainer
end
