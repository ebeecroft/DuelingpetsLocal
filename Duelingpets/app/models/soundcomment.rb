class Soundcomment < ActiveRecord::Base
   attr_accessible :message, :critique

   #Soundcomment related
   belongs_to :user
   belongs_to :sound

   #Validation section
   validates :message, presence: true
end
