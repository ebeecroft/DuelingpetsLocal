class Pastforumowner < ActiveRecord::Base
   #Pastforumowner related
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :pastowner, :class_name => 'User', :foreign_key => 'pastowner_id'
   belongs_to :forum
end
