class ContainermoderatorsController < ApplicationController
   include ContainermoderatorsHelper

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
