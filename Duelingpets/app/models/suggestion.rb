class Suggestion < ActiveRecord::Base
   attr_accessible :title, :description

   #Suggestion related
   belongs_to :user

   #Regex information for suggestions
   VALID_TITLE_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates section
   validates :title, presence: true, format: {with: VALID_TITLE_REGEX}
   validates :description, presence: true

   #Overides the default parameters to use title in place of the id code
   def to_param
      title
   end
end
