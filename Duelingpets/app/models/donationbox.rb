class Donationbox < ActiveRecord::Base
   attr_accessible :description, :goal, :turn_on

   #Donors related
   has_many :donors, :foreign_key => "donationbox_id", :dependent => :destroy
   belongs_to :user

   #Regex for points
   VALID_POINTS_REGEX = /\A[0-9]+\z/

   #Validates donationbox upon editing
   validates :goal, presence: true, format: {with: VALID_POINTS_REGEX}
   validates :description, presence: true
end
