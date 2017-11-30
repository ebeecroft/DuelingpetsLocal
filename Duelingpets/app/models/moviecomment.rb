class Moviecomment < ActiveRecord::Base
   attr_accessible :message, :critique

   #Moviecomment related
   belongs_to :user
   belongs_to :movie

   #Validation section
   validates :message, presence: true
end
