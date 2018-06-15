module ForuminvitesHelper

   private
      def destroyCommons
         inviteFound = Foruminvite.find_by_id(params[:id])
         if(inviteFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == inviteFound.from_user_id) || logged_in.admin))
               @foruminvite = inviteFound
               @user = User.find_by_vname(inviteFound.from_user.vname)
               flash[:success] = "Foruminvite was successfully removed."
               @foruminvite.destroy
               if(logged_in.admin)
                  redirect_to foruminvites_path
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
                  allInvites = Foruminvite.order("created_on desc")
                  @foruminvites = Kaminari.paginate_array(allInvites).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               forumMode = Maintenancemode.find_by_id(10)
               if(allMode.maintenance_on || forumMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/forums/maintenance"
                  end
               else
                  forumFound = Forum.find_by_name(params[:forum_id])
                  if(forumFound)
                     logged_in = current_user
                     if(logged_in && forumFound.user_id == logged_in.id)
                        newInvite = forumFound.foruminvites.new
                        if(type == "create")
                           newInvite = forumFound.foruminvites.new(params[:foruminvite])
                           newInvite.created_on = currentTime
                           newInvite.from_user_id = logged_in.id
                           newInvite.status = "Inprocess"
                        end
                        #Gather the friends list
                        allFriends = Friend.all
                        userFriends = allFriends.select{|friend| (friend.to_user.id == logged_in.id) || (friend.from_user.id == logged_in.id)}
                        friends = []
                        #Build the friends array
                        userFriends.each do |friend|
                           if(friend.to_user.id != logged_in.id)
                              friends.push(friend.to_user.vname)
                           elsif(friend.from_user.id != logged_in.id)
                              friends.push(friend.from_user.vname)
                           end
                        end
                        @foruminvite = newInvite
                        @forum = forumFound
                        @user = friends
                        if(type == "create")
                           chosenFriend = User.find_by_vname(params[:foruminvite][:user_id])
                           newInvite.user_id = chosenFriend.id
                           @foruminvite = newInvite
                           if(@foruminvite.save)
                              UserMailer.foruminvite_review(@foruminvite).deliver
                              flash[:success] = "The foruminvite for #{@foruminvite.to_user.vname} was successfully created."
                              redirect_to user_forum_path(@forum.user, @forum)
                           else
                              render "new"
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy")
               if(current_user && current_user.admin)
                  destroyCommons
               else
                  allMode = Maintenancemode.find_by_id(1)
                  forumMode = Maintenancemode.find_by_id(10)
                  if(allMode.maintenance_on || forumMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/forums/maintenance"
                     end
                  else
                     destroyCommons
                  end
               end
            elsif(type == "inbox" || type == "outbox")
               allMode = Maintenancemode.find_by_id(1)
               forumMode = Maintenancemode.find_by_id(10)
               if(allMode.maintenance_on || forumMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/forums/maintenance"
                  end
               else
                  logged_in = current_user
                  if(logged_in)
                     allInvites = Foruminvite.order("created_on desc")
                     @user = User.find_by_id(logged_in.id)
                     inviteBox = allInvites.select{|foruminvite| ((foruminvite.from_user_id == logged_in.id) && (foruminvite.status != "Inprocess")) || (foruminvite.user_id == logged_in.id)}
                     if(type == "outbox")
                        inviteBox = allInvites.select{|foruminvite| foruminvite.from_user_id == logged_in.id}
                     end
                     @foruminvites = Kaminari.paginate_array(inviteBox).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "approve" || type == "deny")
               allMode = Maintenancemode.find_by_id(1)
               forumMode = Maintenancemode.find_by_id(10)
               if(allMode.maintenance_on || forumMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/forums/maintenance"
                  end
               else
                  logged_in = current_user
                  if(logged_in)
                     inviteFound = Foruminvite.find_by_id(params[:foruminvite_id])
                     if(inviteFound)
                        if((inviteFound.user_id == logged_in.id) && (inviteFound.status == "Inprocess"))
                           if(type == "approve")
                              #Create a new forum member entry
                              inviteFound.status = "Approved"
                              value = "#{inviteFound.from_user.vname}'s foruminvite was approved."

                              #Create the new forum member
                              newForumMember = Foruminvitemember.new(params[:foruminvitemember])
                              newForumMember.user_id = inviteFound.user_id
                              newForumMember.forum_id = inviteFound.forum_id
                              newForumMember.created_on = currentTime
                              @foruminvitemember = newForumMember
                              @foruminvitemember.save
                              UserMailer.foruminvite_approved(@foruminvitemember).deliver
                           else
                              inviteFound.status = "Denied"
                              UserMailer.foruminvite_denied(inviteFound).deliver
                              value = "#{inviteFound.from_user.vname}'s foruminvite was denied."
                           end
                           @foruminvite = inviteFound
                           @foruminvite.save
                           flash[:success] = value
                           redirect_to foruminvites_inbox_path
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
