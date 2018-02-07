class Forumtype < ActiveRecord::Base

   #Forums
   has_many :forums, :foreign_key => "forumtype_id", :dependent => :destroy
end
