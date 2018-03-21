class Blacklisteddomain < ActiveRecord::Base
   attr_accessible :name, :domain_only

   #Regex information for blacklisteddomains
   VALID_DOMAIN_REGEX = /\A[a-z][a-z][a-z0-9!-.]+\.[a-z0-9]+\z/i

   #Validates the blacklisteddomain upon submission
   validates :name, presence: true, format: {with: VALID_DOMAIN_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
