class ContainersubscribersController < ApplicationController
   include ContainersubscribersHelper

   def index
      mode "index"
   end

   def subscribe
      mode "subscribe"
   end

   def destroy
      mode "destroy"
   end

   def list
      mode "list"
   end
end
