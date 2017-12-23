class Mainsheet < ActiveRecord::Base
   attr_accessible :title, :description

   #Mainsheet related
   belongs_to :radiostation
   belongs_to :user
   has_many :subsheets, :foreign_key => "mainsheet_id", :dependent => :destroy

   #Regex information for mainsheet
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the mainsheet information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
