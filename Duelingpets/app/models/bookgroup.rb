class Bookgroup < ActiveRecord::Base

   #Channels
   has_many :subplaylists, :foreign_key => "bookgroup_id", :dependent => :destroy
   has_many :movies, :foreign_key => "bookgroup_id", :dependent => :destroy
end
