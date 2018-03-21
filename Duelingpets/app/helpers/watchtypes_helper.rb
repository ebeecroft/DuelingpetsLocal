module WatchtypesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allWatches = Watchtype.order("created_on desc")
                  @watchtypes = Kaminari.paginate_array(allWatches).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newWatch = Watchtype.new
                  if(type == "create")
                     newWatch = Watchtype.new(params[:watchtype])
                     newWatch.created_on = currentTime
                  end
                  @watchtype = newWatch
                  if(type == "create")
                     if(@watchtype.save)
                        flash[:success] = "The watchtype #{@watchtype.name} has been successfully created."
                        redirect_to watchtypes_path
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  watchFound = Watchtype.find_by_name(params[:id])
                  if(watchFound)
                     @watchtype = watchFound
                     if(type == "update")
                        if(@watchtype.update_attributes(params[:watchtype]))
                           flash[:success] = "The watchtype #{@watchtype.name} was successfully updated."
                           redirect_to watchtypes_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "The watchtype #{@watchtype.name} was successfully removed."
                        @watchtype.destroy
                        redirect_to watchtypes_path
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
