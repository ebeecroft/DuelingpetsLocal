class FavoritesoundsController < ApplicationController
   include FavoritesoundsHelper

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
end
