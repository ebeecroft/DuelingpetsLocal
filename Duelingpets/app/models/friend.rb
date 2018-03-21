class Friend < ActiveRecord::Base
   #Friend related
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
end
