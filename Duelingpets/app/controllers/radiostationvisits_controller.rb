class RadiostationvisitsController < ApplicationController
   include RadiostationvisitsHelper

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
