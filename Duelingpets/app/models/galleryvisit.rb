class Galleryvisit < ActiveRecord::Base
   #Galleryvisit related
   belongs_to :user
   belongs_to :gallery
end
