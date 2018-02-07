class Favoritesound < ActiveRecord::Base
   attr_accessible :subsheet_id

   #FavoriteSound related
   belongs_to :user
   belongs_to :sound
   belongs_to :subsheet
end
