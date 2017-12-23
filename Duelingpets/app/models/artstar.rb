class Artstar < ActiveRecord::Base

   #Artstar related
   belongs_to :user
   belongs_to :art
end
