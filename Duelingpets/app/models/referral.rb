class Referral < ActiveRecord::Base
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :referred_by, :class_name => 'User', :foreign_key => 'referred_by_id'
end
