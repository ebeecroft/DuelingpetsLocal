class ForumgroupsController < ApplicationController
   include ForumgroupsHelper

   def index
      mode "index"
   end
end
