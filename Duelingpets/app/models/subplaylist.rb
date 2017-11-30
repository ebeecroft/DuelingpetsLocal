class Subplaylist < ActiveRecord::Base
   attr_accessible :title, :description, :collab_mode, :fave_folder, :bookgroup_id

   #Subplaylist releated
   belongs_to :mainplaylist
   belongs_to :user
   belongs_to :bookgroup
   has_many :movies, :foreign_key => "subplaylist_id", :dependent => :destroy
   has_many :favoritemovies, :foreign_key => "subplaylist_id", :dependent => :destroy

   #Regex information for colorscheme
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the subplaylist information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
