class Moviecomment < ActiveRecord::Base
   attr_accessible :message

   #Moviecomment related
   belongs_to :user
   belongs_to :movie

   #Validation section
   validates :message, presence: true
end
