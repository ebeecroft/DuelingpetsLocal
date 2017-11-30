class User < ActiveRecord::Base
   attr_accessible :first_name, :last_name, :email, :birthday, :vname, :login_id, 
   :country, :country_timezone, :military_time, :password, :password_confirmation

   #Pms
   has_many :pmreplies, :foreign_key => "user_id", :dependent => :destroy
   has_many :pms, :foreign_key => "user_id", :dependent => :destroy

   #Blogs
   has_many :replies, :foreign_key => "user_id", :dependent => :destroy
   has_many :blogs, :foreign_key => "user_id", :dependent => :destroy

   #Shouts for messaging users
   has_many :shouts, :foreign_key => "user_id", :dependent => :destroy

   #Pouch for storing money
   has_one :pouch, :foreign_key => "user_id", :dependent => :destroy

   #User info
   has_one :userinfo, :foreign_key => "user_id", :dependent => :destroy

   #Colorscheme
   has_many :colorschemes, :foreign_key => "user_id", :dependent => :destroy

   #Suggestions
   has_many :suggestions, :foreign_key => "user_id", :dependent => :destroy

   #Referrals
   has_one :referral, :foreign_key => "user_id", :dependent => :destroy
   has_many :referrals, :foreign_key => "referred_by_id", :dependent => :destroy

   #Donationboxes
   has_one :donationbox, :foreign_key => "user_id", :dependent => :destroy
   has_many :donors, :foreign_key => "user_id", :dependent => :destroy

   #Channels
   has_many :channels, :foreign_key => "user_id", :dependent => :destroy
   has_many :mainplaylists, :foreign_key => "user_id", :dependent => :destroy
   has_many :subplaylists, :foreign_key => "user_id", :dependent => :destroy
   has_many :movies, :foreign_key => "user_id", :dependent => :destroy
   has_many :moviecomments, :foreign_key => "user_id", :dependent => :destroy
   has_many :moviestars, :foreign_key => "user_id", :dependent => :destroy
   has_many :favoritemovies, :foreign_key => "user_id", :dependent => :destroy

   #Galleries
   has_many :galleries, :foreign_key => "user_id", :dependent => :destroy
   has_many :mainfolders, :foreign_key => "user_id", :dependent => :destroy
   has_many :subfolders, :foreign_key => "user_id", :dependent => :destroy
   has_many :arts, :foreign_key => "user_id", :dependent => :destroy

   #Regex code for managing the user section
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9]+\z/i
   VALID_CTIMEZONE_REGEX = /\A[a-z][a-z][a-z0-9-]+\z/i
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9\d\-.]+\.[a-z0-9]+\z/i
   VALID_VNAME_REGEX = /\A[a-z][a-z][a-z][a-z0-9-]+\z/i

   #Validates the user information upon submission
   validates :first_name, presence: true, format: {with: VALID_NAME_REGEX}
   validates :last_name, presence: true, format: {with: VALID_NAME_REGEX}
   validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
   validates :country, presence: true, format: {with: VALID_NAME_REGEX}
   validates :country_timezone, presence: true
   validates :birthday, presence: true
   validates :vname, presence: true, format: {with: VALID_VNAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :login_id, presence: true, format: {with: VALID_VNAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :password, length: {minimum: 6}
   validates :password_confirmation, presence: true

   #Saving parameters that get changed
   has_secure_password
   before_save {|user| user.first_name = user.first_name.humanize}
   before_save {|user| user.last_name = user.last_name.humanize}
   before_save {|user| user.email = user.email.downcase}

   #Overides the default parameters to use vname in place of the id code
   def to_param
      vname
   end
end
