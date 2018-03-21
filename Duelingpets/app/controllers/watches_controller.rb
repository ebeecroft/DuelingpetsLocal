class WatchesController < ApplicationController
   include WatchesHelper

   def index
      mode "index"
   end

   def new
      mode "new"
   end

   def create
      mode "create"
   end

   def destroy
      mode "destroy"
   end

   def watchers
      mode "watchers"
   end

   def watching
      mode "watching"
   end
end
