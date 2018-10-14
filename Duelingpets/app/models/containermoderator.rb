class Containermoderator < ActiveRecord::Base
   #Containermoderator related
   belongs_to :user
   belongs_to :topiccontainer
end
