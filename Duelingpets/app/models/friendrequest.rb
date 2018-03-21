class Friendrequest < ActiveRecord::Base
   attr_accessible :message

   #Friendrequest related
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'

   #Validates the friendrequest information upon submission
   validates :message, presence: true
end
