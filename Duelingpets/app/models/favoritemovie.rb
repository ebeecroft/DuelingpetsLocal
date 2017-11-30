class Favoritemovie < ActiveRecord::Base
   attr_accessible :subplaylist_id

   #FavoriteMovie related
   belongs_to :user
   belongs_to :movie
   belongs_to :subplaylist
end
