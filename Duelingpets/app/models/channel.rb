class Channel < ActiveRecord::Base
   attr_accessible :name, :description

   #Channel related
   has_many :mainplaylists, :foreign_key => "channel_id", :dependent => :destroy
   belongs_to :user

   #Regex information for colorscheme
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the channel information upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :description, presence: true

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
