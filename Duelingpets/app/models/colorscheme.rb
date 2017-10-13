class Colorscheme < ActiveRecord::Base
   attr_accessible :name, :description, :activate, :backgroundcolor, :headercolor, :textcolor, 
   :navigationcolor, :navigationlinkcolor, :navigationhovercolor, :navigationhoverbackgcolor,
   :onlinestatuscolor, :profilecolor, :profilevisitedcolor, :profilehovercolor,
   :profilehoverbackgcolor, :sessioncolor, :navlinkcolor, :navlinkhovercolor,
   :navlinkhoverbackgcolor, :explanationborder, :explanationbackgcolor, :explanheadercolor,
   :explanheaderbackgcolor, :errorcolor, :warningcolor, :notificationcolor, :successcolor

   #Colorscheme related
   has_many :userinfos
   belongs_to :user

   #Regex information for colorscheme
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9!-]+\z/i
   VALID_COLOR_REGEX = /\A[#][0-9a-f]+\z/i

   #Validates the colorscheme information upon submission
   validates :name, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :description, presence: true
   validates :backgroundcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :headercolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :textcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navigationcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navigationlinkcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navigationhovercolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navigationhoverbackgcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :onlinestatuscolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :profilecolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :profilevisitedcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :profilehovercolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :profilehoverbackgcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :sessioncolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navlinkcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navlinkhovercolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :navlinkhoverbackgcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :explanationborder, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :explanationbackgcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :explanheadercolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :explanheaderbackgcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :errorcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :warningcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :notificationcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}
   validates :successcolor, presence: true, length: {is: 7}, format: {with: VALID_COLOR_REGEX}

   #Overides the default parameters to use name in place of the id code
   def to_param
      name
   end
end
