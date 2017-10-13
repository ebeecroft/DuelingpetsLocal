class Moviestar < ActiveRecord::Base

   #Moviestar related
   belongs_to :user
   belongs_to :movie
end
