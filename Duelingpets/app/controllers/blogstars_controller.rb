class BlogstarsController < ApplicationController
   include BlogstarsHelper

   def index
      mode "index"
   end

   def star
      mode "star"
   end

   def destroy
      mode "destroy"
   end
end
