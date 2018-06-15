class Blogvisit < ActiveRecord::Base
   #Blogvisit related
   belongs_to :user
   belongs_to :blog
end
