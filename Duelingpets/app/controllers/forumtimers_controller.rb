class ForumtimersController < ApplicationController
   include ForumtimersHelper

   def index
      mode "index"
   end
end
