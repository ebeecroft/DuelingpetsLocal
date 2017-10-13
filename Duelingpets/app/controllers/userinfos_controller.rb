class UserinfosController < ApplicationController
   include UserinfosHelper

   def index
      mode "index"
   end

   def edit
      mode "edit"
   end

   def update
      mode "update"
   end
end
