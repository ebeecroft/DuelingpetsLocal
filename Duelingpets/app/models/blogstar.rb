class Blogstar < ActiveRecord::Base

   #Blogstar related
   belongs_to :user
   belongs_to :blog
end
