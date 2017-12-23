class Favoriteart < ActiveRecord::Base
   attr_accessible :subfolder_id

   #FavoriteMovie related
   belongs_to :user
   belongs_to :art
   belongs_to :subfolder
end
