class Artcomment < ActiveRecord::Base
   attr_accessible :message, :critique

   #Artcomment related
   belongs_to :user
   belongs_to :art

   #Validation section
   validates :message, presence: true
end
