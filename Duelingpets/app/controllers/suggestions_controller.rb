class SuggestionsController < ApplicationController
   include SuggestionsHelper

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

   def applied
      mode "applied"
   end
end
