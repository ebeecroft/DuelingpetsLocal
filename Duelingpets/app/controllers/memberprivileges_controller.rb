class MemberprivilegesController < ApplicationController
   include MemberprivilegesHelper

   def index
      mode "index"
   end
end
