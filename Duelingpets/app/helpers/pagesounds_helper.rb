module PagesoundsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allSounds = Pagesound.order("created_on desc")
                  @pagesounds = Kaminari.paginate_array(allSounds).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newSound = Pagesound.new
                  if(type == "create")
                     newSound = Pagesound.new(params[:pagesound])
                     newSound.created_on = currentTime
                  end
                  @pagesound = newSound
                  if(type == "create")
                     if(@pagesound.save)
                        flash[:success] = "The pagesound #{@pagesound.name} has been successfully created."
                        redirect_to pagesounds_path
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  soundFound = Pagesound.find_by_name(params[:id])
                  if(soundFound)
                     @pagesound = soundFound
                     if(type == "update")
                        if(@pagesound.update_attributes(params[:pagesound]))
                           flash[:success] = "The pagesound #{@pagesound.name} was successfully updated."
                           redirect_to pagesounds_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "The pagesound #{@pagesound.name} was successfully removed."
                        @pagesound.destroy
                        redirect_to pagesounds_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
