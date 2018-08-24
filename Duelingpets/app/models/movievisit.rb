class Movievisit < ActiveRecord::Base
   #Movievisit related
   belongs_to :user
   belongs_to :movie
end
