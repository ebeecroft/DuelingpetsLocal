class Memberprivilege < ActiveRecord::Base

   #Forums
   has_many :forums, :foreign_key => "memberprivilege_id", :dependent => :destroy
end
