class RadiostationsController < ApplicationController
   include RadiostationsHelper

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

   def videocontrol
      mode "videocontrol"
   end

   def gvideocontrol
      mode "gvideocontrol"
   end

   def list
      mode "list"
   end
end
