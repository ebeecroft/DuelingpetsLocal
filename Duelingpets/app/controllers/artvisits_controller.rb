class ArtvisitsController < ApplicationController
   include ArtvisitsHelper

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
