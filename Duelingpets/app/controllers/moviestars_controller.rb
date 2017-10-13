class MoviestarsController < ApplicationController
   include MoviestarsHelper

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
