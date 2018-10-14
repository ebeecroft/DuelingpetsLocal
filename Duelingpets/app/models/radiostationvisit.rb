class Radiostationvisit < ActiveRecord::Base
   #Radiostationvisit related
   belongs_to :user
   belongs_to :radiostation
end
