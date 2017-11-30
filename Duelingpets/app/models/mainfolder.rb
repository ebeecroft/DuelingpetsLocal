class Mainfolder < ActiveRecord::Base
   attr_accessible :title, :description

   #Mainfolder related
   belongs_to :gallery
   belongs_to :user
   has_many :subfolders, :foreign_key => "mainfolder_id", :dependent => :destroy

   #Regex information for mainfolder
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the mainfolder information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
