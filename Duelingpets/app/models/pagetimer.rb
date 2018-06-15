class Pagetimer < ActiveRecord::Base
   attr_accessible :name, :duration, :timeformat

   #Regex information for pagetimer
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i
   VALID_DURATION_REGEX = /\A[0-6][0-9]\z/i
   VALID_TIME_REGEX = /\A[a-z]+\z/i

   #Validation section
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :duration, presence: true, format: {with: VALID_DURATION_REGEX}
   validates :timeformat, presence: true, format: {with: VALID_TIME_REGEX}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
