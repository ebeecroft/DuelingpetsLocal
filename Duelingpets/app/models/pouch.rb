class Pouch < ActiveRecord::Base
   attr_accessible :privilege
   belongs_to :user
end
