class SessionsController < ApplicationController
   include SessionsHelper

   def loginpost
      mode "loginpost"
   end

   def recoverypost
      mode "recoverypost"
   end

   def activatepost
      mode "activatepost"
   end

   def resettimepost
      mode "resettimepost"
   end

   def destroy
      mode "destroy"
   end
end
