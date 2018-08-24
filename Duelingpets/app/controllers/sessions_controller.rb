class SessionsController < ApplicationController
   include SessionsHelper

   def login
      mode "login"
   end

   def activate
      mode "activate"
   end

   def recover
      mode "recover"
   end

   def resettime
      mode "resettime"
   end

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
