class Soundstar < ActiveRecord::Base

   #Soundstar related
   belongs_to :user
   belongs_to :sound
end
