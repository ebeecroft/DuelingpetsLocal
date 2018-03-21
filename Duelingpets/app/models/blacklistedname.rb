class Blacklistedname < ActiveRecord::Base
   attr_accessible :name

   #Regex information for blacklistednames
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Validates the blacklistedname upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
