class Artvisit < ActiveRecord::Base
   #Artvisit related
   belongs_to :user
   belongs_to :art
end
