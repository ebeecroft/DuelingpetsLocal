class SoundstarsController < ApplicationController
   include SoundstarsHelper

   def index
      mode "index"
   end

   def star
      mode "star"
   end

   def destroy
      mode "destroy"
   end
end
