class BlogvisitsController < ApplicationController
   include BlogvisitsHelper

   def index
      mode "index"
   end

   def destroy
      mode "destroy"
   end

   def visitlist
      mode "visitlist"
   end
end
