class Bookgroup < ActiveRecord::Base

   #Channels
   has_many :subplaylists, :foreign_key => "bookgroup_id", :dependent => :destroy
   has_many :movies, :foreign_key => "bookgroup_id", :dependent => :destroy

   #Galleries
   has_many :subfolders, :foreign_key => "bookgroup_id", :dependent => :destroy
   has_many :arts, :foreign_key => "bookgroup_id", :dependent => :destroy

   #Radios
   has_many :subsheets, :foreign_key => "bookgroup_id", :dependent => :destroy
   has_many :sounds, :foreign_key => "bookgroup_id", :dependent => :destroy
end
