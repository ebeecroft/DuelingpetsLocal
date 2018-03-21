module WatchesHelper

   private
      def watchCommons(type)
         userFound = User.find_by_vname(params[:user_id])
         if(userFound)
            allWatches = Watch.order("created_on desc")
            userWatches = allWatches.select{|watch| watch.user_id == userFound.id}
            if(type == "watching")
               userWatches = allWatches.select{|watch| watch.from_user_id == userFound.id}
            end
            @user = userFound
            @watches = Kaminari.paginate_array(userWatches).page(params[:page]).per(10)
         else
            render "start/crazybat"
         end
      end

      def destroyCommons
         watchFound = Watch.find_by_id(params[:id])
         if(watchFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == watchFound.from_user_id) || logged_in.admin))
               @watch = watchFound
               @user = User.find_by_vname(watchFound.from_user.vname)
               flash[:success] = "Watch was successfully removed."
               @watch.destroy
               if(logged_in.admin)
                  redirect_to watches_path
               else
                  redirect_to user_path(@user)
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allWatches = Watch.order("created_on desc")
                  @watches = Kaminari.paginate_array(allWatches).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/users/maintenance"
                  end
               else
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id != userFound.id)
                        #Finds all of the user's watches
                        allWatches = Watch.all
                        userWatches = allWatches.select{|watch| watch.from_user_id == logged_in.id}
                        watchFound = userWatches

                        #Determines if the user is already watching the given user
                        if(userWatches.count != 0)
                           watchFound = userWatches.select{|watch| watch.user_id == userFound.id}
                        end
                        if(watchFound.count == 0)
                           newWatch = userFound.watches.new
                           if(type == "create")
                              newWatch = userFound.watches.new(params[:watch])
                              newWatch.from_user_id = logged_in.id
                              newWatch.created_on = currentTime
                           end
                           @watch = newWatch
                           @user = userFound
                           @type = Watchtype.all
                           if(type == "create")
                              if(@watch.save)
                                 pouch = Pouch.find_by_user_id(@watch.to_user.id)
                                 pointsForWatch = @watch.watchtype.amount
                                 pouch.amount += pointsForWatch
                                 UserMailer.watch_created(@watch, pointsForWatch).deliver
                                 @pouch = pouch
                                 @pouch.save
                                 flash[:success] = "You are now watching #{@watch.to_user.vname}."
                                 redirect_to user_path(@user)
                              else
                                 render "new"
                              end
                           end
                        else
                           redirect_to root_path
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "destroy")
               if(current_user && current_user.admin)
                  destroyCommons
               else
                  allMode = Maintenancemode.find_by_id(1)
                  userMode = Maintenancemode.find_by_id(5)
                  if(allMode.maintenance_on || userMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  else
                     destroyCommons
                  end
               end
            elsif(type == "watchers" || type == "watching")
               if(current_user && current_user.admin)
                  watchCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  userMode = Maintenancemode.find_by_id(5)
                  if(allMode.maintenance_on || userMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  else
                     watchCommons(type)
                  end
               end
            end
         end
      end
end
