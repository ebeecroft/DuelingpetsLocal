class Maintopicmoderator < ActiveRecord::Base
   #Maintopicmoderator related
   belongs_to :user
   belongs_to :maintopic
end
