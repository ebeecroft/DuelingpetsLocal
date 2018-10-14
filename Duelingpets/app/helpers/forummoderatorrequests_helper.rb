module ForummoderatorrequestsHelper

   private
      def destroyCommons
         requestFound = Forummoderatorrequest.find_by_id(params[:id])
         if(requestFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == requestFound.forum.user_id) || logged_in.admin))
               @forummoderatorrequest = requestFound
               @user = User.find_by_vname(requestFound.user.vname)
               flash[:success] = "Moderator request was successfully removed."
               @forummoderatorrequest.destroy
               if(logged_in.admin)
                  redirect_to forummoderatorrequests_path
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
                  allRequests = Forummoderatorrequest.order("created_on desc")
                  @forummoderatorrequests = Kaminari.paginate_array(allRequests).page(params[:page]).per(10)
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
                     if(logged_in && forumFound.user_id != logged_in.id)
                        newRequest = forumFound.forummoderatorrequests.new
                        if(type == "create")
                           newRequest = forumFound.forummoderatorrequests.new(params[:forummoderatorrequest])
                           newRequest.created_on = currentTime
                           newRequest.status = "Inprocess"
                           newRequest.user_id = logged_in.id
                        end
                        @forummoderatorrequest = newRequest
                        @forum = forumFound
                        if(type == "create")
                           if(@forummoderatorrequest.save)
#                              UserMailer.foruminvite_review(@foruminvite).deliver
                              flash[:success] = "The modrequest for #{@forummoderatorrequest.user.vname} was successfully created."
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
            elsif(type == "review")
               logged_in = current_user
               if(logged_in)
                  forumFound = Forum.find_by_name(params[:forum_id])
                  if(forumFound)
                     if(forumFound.user_id == logged_in.id)
                        forumRequests = forumFound.forummoderatorrequests.order("created_on desc")
                        reviewRequests = forumRequests.select{|request| request.status == "Inprocess"}
                        @forummoderatorrequests = Kaminari.paginate_array(reviewRequests).page(params[:page]).per(10)
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               else
                  redirect_to root_path
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
                     requestFound = Forummoderatorrequest.find_by_id(params[:forummoderatorrequest_id])
                     if(requestFound)
                        if((requestFound.forum.user_id == logged_in.id) && (requestFound.status == "Inprocess"))
                           if(type == "approve")
                              #Create a new forum member entry
                              requestFound.status = "Approved"
                              value = "#{requestFound.user.vname}'s forummoderatorrequest was approved."

                              #Create the new forum member
                              newForumModerator = Forummoderator.new(params[:forummoderator])
                              newForumModerator.user_id = requestFound.user_id
                              newForumModerator.forum_id = requestFound.forum_id
                              newForumModerator.created_on = currentTime
                              @forummoderator = newForumModerator
                              @forummoderator.save
                              #UserMailer.foruminvite_approved(@foruminvitemember).deliver
                              #Delete after approving
                              #Remember to delete the container and maintopic ones
                           else
                              requestFound.status = "Denied"
                              #UserMailer.foruminvite_denied(inviteFound).deliver
                              value = "#{requestFound.user.vname}'s forummoderatorrequest was denied."
                              #Delete after denying
                           end
                           @forummoderatorrequest = requestFound
                           @forummoderatorrequest.save
                           flash[:success] = value
                           redirect_to forum_forummoderatorrequests_review_path(@forummoderatorrequest.forum)
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
