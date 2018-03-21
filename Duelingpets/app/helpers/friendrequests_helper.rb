module FriendrequestsHelper

   private
      def destroyCommons
         requestFound = Friendrequest.find_by_id(params[:id])
         if(requestFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == requestFound.from_user_id) || logged_in.admin))
               @friendrequest = requestFound
               @user = User.find_by_vname(requestFound.from_user.vname)
               flash[:success] = "Friendrequest was successfully removed."
               @friendrequest.destroy
               if(logged_in.admin)
                  redirect_to friendrequests_path
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
                  allRequests = Friendrequest.order("created_on desc")
                  @friendrequests = Kaminari.paginate_array(allRequests).page(params[:page]).per(10)
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
                        #Find all of the user's requests
                        allRequests = Friendrequest.all
                        requestStatus = allRequests.select{|friend| friend.status == "Inprocess" || friend.status == "Approved"}
                        userRequests = requestStatus.select{|friend| ((friend.user_id == userFound.id) && (friend.from_user_id == logged_in.id)) || ((friend.user_id == logged_in.id) && (friend.from_user_id == userFound.id))}

                        #Will need to expand this once friends are working
                        #Also should remove friendrequests past a certain amount of time
                        if(userRequests.count == 0)
                           newRequest = userFound.friendrequests.new
                           if(type == "create")
                              newRequest = userFound.friendrequests.new(params[:friendrequest])
                              newRequest.from_user_id = logged_in.id
                              newRequest.created_on = currentTime
                              newRequest.status = "Inprocess"
                           end
                           @friendrequest = newRequest
                           @user = userFound
                           if(type == "create")
                              if(@friendrequest.save)
                                 UserMailer.friendrequest_review(@friendrequest).deliver
                                 flash[:success] = "Friendrequest sent to #{@friendrequest.to_user.vname} was successfully created."
                                 redirect_to user_path(@friendrequest.from_user)
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
            elsif(type == "inbox" || type == "outbox")
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
                  if(logged_in)
                     allRequests = Friendrequest.order("created_on desc")
                     @user = User.find_by_id(logged_in.id)
                     requestBox = allRequests.select{|friend| ((friend.from_user_id == logged_in.id) && (friend.status != "Inprocess")) || (friend.user_id == logged_in.id)}
                     if(type == "outbox")
                        requestBox = allRequests.select{|friend| friend.from_user_id == logged_in.id}
                     end
                     @friendrequests = Kaminari.paginate_array(requestBox).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "approve" || type == "deny")
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
                  if(logged_in)
                     requestFound = Friendrequest.find_by_id(params[:friendrequest_id])
                     if(requestFound)
                        if((requestFound.user_id == logged_in.id) && (requestFound.status == "Inprocess"))
                           if(type == "approve")
                              #Create a new friend entry
                              requestFound.status = "Approved"
                              value = "#{requestFound.from_user.vname}'s friendrequest was approved."

                              #Create the new friend
                              newFriend = Friend.new(params[:friend])
                              newFriend.user_id = requestFound.user_id
                              newFriend.from_user_id = requestFound.from_user_id
                              newFriend.created_on = currentTime
                              @friend = newFriend
                              @friend.save
                              UserMailer.friendrequest_approved(@friend).deliver
                           else
                              requestFound.status = "Denied"
                              UserMailer.friendrequest_denied(requestFound).deliver
                              value = "#{requestFound.from_user.vname}'s friendrequest was denied."
                           end
                           @friendrequest = requestFound
                           @friendrequest.save
                           flash[:success] = value
                           redirect_to friendrequests_inbox_path
                        else
                           redirect_to root_path
                        end
                     else
                        render "start/crazybat"
                     end
                  else
                     redirect_to root_path
                  end
               end
            end
         end
      end
end
