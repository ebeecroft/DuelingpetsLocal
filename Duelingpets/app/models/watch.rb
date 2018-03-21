class Watch < ActiveRecord::Base
   attr_accessible :watchtype_id

   #Watch related
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
   belongs_to :watchtype
end
