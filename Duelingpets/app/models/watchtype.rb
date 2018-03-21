class Watchtype < ActiveRecord::Base
   attr_accessible :name, :amount

   #Regex information for name
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i

   #Watchtype related
   has_one :watch, :foreign_key => "watchtype_id", :dependent => :destroy

   #Validates the watchtype information upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
