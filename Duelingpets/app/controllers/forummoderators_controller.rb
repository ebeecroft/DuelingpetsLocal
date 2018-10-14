class ForummoderatorsController < ApplicationController
   include ForummoderatorsHelper

   def index
      mode "index"
   end

   def destroy
      mode "destroy"
   end

   def modlist
      mode "modlist"
   end

   def unmoderate
      mode "unmoderate"
   end
end
