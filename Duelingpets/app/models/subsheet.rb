class Subsheet < ActiveRecord::Base
   attr_accessible :title, :description, :collab_mode, :fave_folder, :bookgroup_id

   #Subsheet related
   belongs_to :mainsheet
   belongs_to :user
   belongs_to :bookgroup
   has_many :sounds, :foreign_key => "subsheet_id", :dependent => :destroy
   has_many :favoritesounds, :foreign_key => "subsheet_id", :dependent => :destroy

   #Regex information for subsheet
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the subsheet information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
