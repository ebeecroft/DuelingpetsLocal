class ForumtypesController < ApplicationController
   include ForumtypesHelper

   def index
      mode "index"
   end
end
