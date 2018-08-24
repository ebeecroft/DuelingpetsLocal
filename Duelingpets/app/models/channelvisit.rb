class Channelvisit < ActiveRecord::Base
   #Channelvisit related
   belongs_to :user
   belongs_to :channel
end
