module ContainermoderatorrequestsHelper

   private
      def destroyCommons
         requestFound = Containermoderatorrequest.find_by_id(params[:id])
         if(requestFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == requestFound.topiccontainer.forum.user_id) || logged_in.admin))
               @containermoderatorrequest = requestFound
               @user = User.find_by_vname(requestFound.user.vname)
               flash[:success] = "Moderator request was successfully removed."
               @containermoderatorrequest.destroy
               if(logged_in.admin)
                  redirect_to containermoderatorrequests_path
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
                  allRequests = Containermoderatorrequest.order("created_on desc")
                  @containermoderatorrequests = Kaminari.paginate_array(allRequests).page(params[:page]).per(10)
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
                  containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
                  if(containerFound)
                     logged_in = current_user
                     if(logged_in && containerFound.forum.user_id != logged_in.id)
                        newRequest = containerFound.containermoderatorrequests.new
                        if(type == "create")
                           newRequest = containerFound.containermoderatorrequests.new(params[:containermoderatorrequest])
                           newRequest.created_on = currentTime
                           newRequest.status = "Inprocess"
                           newRequest.user_id = logged_in.id
                        end
                        @containermoderatorrequest = newRequest
                        @topiccontainer = containerFound
                        if(type == "create")
                           if(@containermoderatorrequest.save)
#                              UserMailer.foruminvite_review(@foruminvite).deliver
                              flash[:success] = "The modrequest for #{@containermoderatorrequest.user.vname} was successfully created."
                              redirect_to user_forum_path(@topiccontainer.forum.user, @topiccontainer.forum)
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
                  containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
                  if(containerFound)
                     if(containerFound.forum.user_id == logged_in.id)
                        containerRequests = containerFound.containermoderatorrequests.order("created_on desc")
                        reviewRequests = containerRequests.select{|request| request.status == "Inprocess"}
                        @containermoderatorrequests = Kaminari.paginate_array(reviewRequests).page(params[:page]).per(10)
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
                     requestFound = Containermoderatorrequest.find_by_id(params[:containermoderatorrequest_id])
                     if(requestFound)
                        if((requestFound.topiccontainer.forum.user_id == logged_in.id) && (requestFound.status == "Inprocess"))
                           if(type == "approve")
                              #Create a new forum member entry
                              requestFound.status = "Approved"
                              value = "#{requestFound.user.vname}'s containermoderatorrequest was approved."

                              #Create the new forum member
                              newContainerModerator = Containermoderator.new(params[:containermoderator])
                              newContainerModerator.user_id = requestFound.user_id
                              newContainerModerator.topiccontainer_id = requestFound.topiccontainer_id
                              newContainerModerator.created_on = currentTime
                              @containermoderator = newContainerModerator
                              @containermoderator.save
                              #UserMailer.foruminvite_approved(@foruminvitemember).deliver
                              #Delete after approving
                           else
                              requestFound.status = "Denied"
                              #UserMailer.foruminvite_denied(inviteFound).deliver
                              value = "#{requestFound.user.vname}'s containermoderatorrequest was denied."
                              #Delete after denying
                           end
                           @containermoderatorrequest = requestFound
                           @containermoderatorrequest.save
                           flash[:success] = value
                           redirect_to topiccontainer_containermoderatorrequests_review_path(@containermoderatorrequest.topiccontainer)
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
