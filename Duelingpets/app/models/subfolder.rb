class Subfolder < ActiveRecord::Base
   attr_accessible :title, :description, :collab_mode, :fave_folder, :bookgroup_id

   #Subfolder related
   belongs_to :mainfolder
   belongs_to :user
   belongs_to :bookgroup
   has_many :arts, :foreign_key => "subfolder_id", :dependent => :destroy

   #Regex information for subfolder
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the subplaylist information upon submission
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
