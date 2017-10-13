class Pm < ActiveRecord::Base
   attr_accessible :title, :message

   #Pm users
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   has_many :pmreplies, :foreign_key => "pm_id", :dependent => :destroy

   #Validates the pm information upon submission
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9-]+\z/i
   validates :title, presence: true, format: { with: VALID_TITLE_REGEX}
   validates :message, presence: true
end
