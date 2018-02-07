class Forumgroup < ActiveRecord::Base

   #Forums
   has_many :subtopics, :foreign_key => "forumgroup_id", :dependent => :destroy
   has_many :narratives, :foreign_key => "forumgroup_id", :dependent => :destroy
end
