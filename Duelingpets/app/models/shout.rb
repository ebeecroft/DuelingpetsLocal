class Shout < ActiveRecord::Base
   attr_accessible :message

   #Validates and link to user model
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   validates :message, presence: true
end
