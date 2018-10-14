class Soundvisit < ActiveRecord::Base
   #Soundvisit related
   belongs_to :user
   belongs_to :sound
end
