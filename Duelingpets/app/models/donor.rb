class Donor < ActiveRecord::Base
   attr_accessible :description, :amount

   #Donors related
   belongs_to :user
   belongs_to :donationbox

   #Regex for points
   VALID_POINTS_REGEX = /\A[0-9]+\z/

   #Validates donors
   validates :amount, presence: true, format: {with: VALID_POINTS_REGEX}
   validates :description, presence: true
end
