class ForuminvitemembersController < ApplicationController
   include ForuminvitemembersHelper

   def index
      mode "index"      
   end

   def destroy
      mode "destroy"
   end

   def memberlist
      mode "memberlist"
   end
end
