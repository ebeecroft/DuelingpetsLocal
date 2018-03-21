class FriendsController < ApplicationController
   include FriendsHelper

   def index
      mode "index"
   end

   def destroy
      mode "destroy"
   end

   def friendlist
      mode "friendlist"
   end
end
