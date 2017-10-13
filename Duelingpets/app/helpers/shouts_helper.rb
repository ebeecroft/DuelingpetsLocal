module ShoutsHelper

   private
      def shoutCommons(logged_in, type)
         userFound = User.find_by_vname(params[:user_id])
         if(userFound)
            @user = userFound
            if(type == "create")
               newShout = userFound.shouts.new(params[:shout])
               newShout.from_user_id = logged_in.id
               newShout.created_on = currentTime
               if(newShout.user_id != newShout.from_user_id)
                  @shout = newShout
                  @shout.save
                  flash[:success] = "#{@shout.from_user.vname} shout was successfully created."
                  redirect_to @user
               else
                  redirect_to root_path
               end
            else
               shoutFound = Shout.find_by_id(params[:id])
               if(shoutFound)
                  if(shoutFound.user_id == logged_in.id || shoutFound.from_user_id == logged_in.id || logged_in.admin)
                     flash[:success] = "Shout was successfully removed."
                     @shout = shoutFound
                     @shout.destroy
                     if(logged_in.admin)
                        redirect_to shouts_path
                     else
                        redirect_to @user
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "start/crazybat"
               end
            end
         else
            redirect_to root_path
         end
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index" || type == "create" || type == "destroy")
               logged_in = current_user
               if(logged_in)
                  if(type == "index")
                     if(logged_in.admin)
                        allShouts = Shout.order("created_on desc").page(params[:page]).per(10)
                        @shouts = allShouts
                     else
                        redirect_to root_path
                     end
                  else
                     if(logged_in.admin)
                        shoutCommons(logged_in, type)
                     else
                        allMode = Maintenancemode.find_by_id(1)
                        userMode = Maintenancemode.find_by_id(5)
                        if(allMode.maintenance_on || userMode.maintenance_on)
                           if(allMode.maintenance_on)
                              render "start/maintenance"
                           else
                              render "users/maintenance"
                           end
                        else
                           shoutCommons(logged_in, type)
                        end
                     end
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
