class PastforumownersController < ApplicationController
   include PastforumownersHelper

   def index
      mode "index"
   end

   def destroy
      mode "destroy"
   end

   def forumownerlist
      mode "forumownerlist"
   end

   def successor
      mode "successor"
   end

   def takecontrol
      mode "takecontrol"
   end
end
