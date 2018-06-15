class Foruminvite < ActiveRecord::Base
   attr_accessible :message, :user_id

   #Foruminvite related
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
   belongs_to :forum

   #Validates the foruminvite information upon submission
   validates :message, presence: true
end
