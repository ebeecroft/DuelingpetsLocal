class Forummoderator < ActiveRecord::Base
   #Forummoderator related
   belongs_to :user
   belongs_to :forum
end
