class ForumsController < ApplicationController
   include ForumsHelper

   def index
      mode "index"
   end

   def show
      mode "show"
   end

   def new
      mode "new"
   end

   def create
      mode "create"
   end

   def edit
      mode "edit"
   end

   def update
      mode "update"
   end

   def destroy
      mode "destroy"
   end

   def musiccontrol
      mode "musiccontrol"
   end

   def gmusiccontrol
      mode "gmusiccontrol"
   end

   def list
      mode "list"
   end
end
