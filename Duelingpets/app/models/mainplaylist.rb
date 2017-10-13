class Mainplaylist < ActiveRecord::Base
   attr_accessible :title, :description

   #Mainplaylist related
   belongs_to :channel
   belongs_to :user
   has_many :subplaylists, :foreign_key => "mainplaylist_id", :dependent => :destroy

   #Regex information for colorscheme
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the mainplaylist information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
