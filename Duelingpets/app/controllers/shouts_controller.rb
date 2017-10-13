class ShoutsController < ApplicationController
   include ShoutsHelper

   def index
      mode "index"
   end

   def create
      mode "create"
   end

   def destroy
      mode "destroy"
   end
end
