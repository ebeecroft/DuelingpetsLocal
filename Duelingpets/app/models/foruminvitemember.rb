class Foruminvitemember < ActiveRecord::Base
   #Foruminvitemember
   belongs_to :forum
   belongs_to :user
end
