module FriendsHelper

   private
      def destroyCommons(type)
         if(type == "destroy")
            friendFound = Friend.find_by_id(params[:id])
            if(friendFound)
               logged_in = current_user
               if(logged_in && (((logged_in.id == friendFound.from_user_id) || (logged_in.id == friendFound.user_id)) || logged_in.admin))
                  @friend = friendFound
                  userFound = User.find_by_vname(friendFound.from_user.vname)
                  if(friendFound.user_id == logged_in.id)
                     userFound = User.find_by_vname(friendFound.to_user.vname)
                  end
                  @user = userFound
                  flash[:success] = "Friend was successfully removed."
                  @friend.destroy
                  if(logged_in.admin)
                     redirect_to friends_path
                  else
                     redirect_to user_path(@user)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Friend list
            userFound = User.find_by_vname(params[:user_id])
            if(userFound)
               allFriends = Friend.order("created_on desc")
               userFriends = allFriends.select{|friend| (friend.from_user_id == userFound.id) || (friend.user_id == userFound.id)}
               @user = userFound
               @friends = Kaminari.paginate_array(userFriends).page(params[:page]).per(10)
            else
               render "start/crazybat"
            end
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
                  allFriends = Friend.order("created_on desc")
                  @friends = Kaminari.paginate_array(allFriends).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "destroy" || type == "friendlist")
               if(current_user && current_user.admin)
                  destroyCommons(type)
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
                     destroyCommons(type)
                  end
               end
            end
         end
      end
end
