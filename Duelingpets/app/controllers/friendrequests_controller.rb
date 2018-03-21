class FriendrequestsController < ApplicationController
   include FriendrequestsHelper

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

   def inbox
      mode "inbox"
   end

   def outbox
      mode "outbox"
   end

   def approve
      mode "approve"
   end

   def deny
      mode "deny"
   end
end
