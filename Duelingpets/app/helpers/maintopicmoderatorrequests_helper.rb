module MaintopicmoderatorrequestsHelper

   private
      def destroyCommons
         requestFound = Maintopicmoderatorrequest.find_by_id(params[:id])
         if(requestFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == requestFound.maintopic.topiccontainer.forum.user_id) || logged_in.admin))
               @maintopicmoderatorrequest = requestFound
               @user = User.find_by_vname(requestFound.user.vname)
               flash[:success] = "Moderator request was successfully removed."
               @maintopicmoderatorrequest.destroy
               if(logged_in.admin)
                  redirect_to maintopicmoderatorrequests_path
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
                  allRequests = Maintopicmoderatorrequest.order("created_on desc")
                  @maintopicmoderatorrequests = Kaminari.paginate_array(allRequests).page(params[:page]).per(10)
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
                  maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
                  if(maintopicFound)
                     logged_in = current_user
                     if(logged_in && maintopicFound.topiccontainer.forum.user_id != logged_in.id)
                        newRequest = maintopicFound.maintopicmoderatorrequests.new
                        if(type == "create")
                           newRequest = maintopicFound.maintopicmoderatorrequests.new(params[:maintopicmoderatorrequest])
                           newRequest.created_on = currentTime
                           newRequest.status = "Inprocess"
                           newRequest.user_id = logged_in.id
                        end
                        @maintopicmoderatorrequest = newRequest
                        @maintopic = maintopicFound
                        if(type == "create")
                           if(@maintopicmoderatorrequest.save)
#                              UserMailer.foruminvite_review(@foruminvite).deliver
                              flash[:success] = "The modrequest for #{@maintopicmoderatorrequest.user.vname} was successfully created."
                              redirect_to forum_topiccontainer_path(@maintopic.topiccontainer.forum, @maintopic.topiccontainer)
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
                  maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
                  if(maintopicFound)
                     if(maintopicFound.topiccontainer.forum.user_id == logged_in.id)
                        maintopicRequests = maintopicFound.maintopicmoderatorrequests.order("created_on desc")
                        reviewRequests = maintopicRequests.select{|request| request.status == "Inprocess"}
                        @maintopicmoderatorrequests = Kaminari.paginate_array(reviewRequests).page(params[:page]).per(10)
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
                     requestFound = Maintopicmoderatorrequest.find_by_id(params[:maintopicmoderatorrequest_id])
                     if(requestFound)
                        if((requestFound.maintopic.topiccontainer.forum.user_id == logged_in.id) && (requestFound.status == "Inprocess"))
                           if(type == "approve")
                              #Create a new forum member entry
                              requestFound.status = "Approved"
                              value = "#{requestFound.user.vname}'s maintopicmoderatorrequest was approved."

                              #Create the new forum member
                              newMaintopicModerator = Maintopicmoderator.new(params[:maintopicmoderator])
                              newMaintopicModerator.user_id = requestFound.user_id
                              newMaintopicModerator.maintopic_id = requestFound.maintopic_id
                              newMaintopicModerator.created_on = currentTime
                              @maintopicmoderator = newMaintopicModerator
                              @maintopicmoderator.save
                              #UserMailer.foruminvite_approved(@foruminvitemember).deliver
                              #Delete after approving
                           else
                              requestFound.status = "Denied"
                              #UserMailer.foruminvite_denied(inviteFound).deliver
                              value = "#{requestFound.user.vname}'s maintopicmoderatorrequest was denied."
                              #Delete after denying
                           end
                           @maintopicmoderatorrequest = requestFound
                           @maintopicmoderatorrequest.save
                           flash[:success] = value
                           redirect_to maintopic_maintopicmoderatorrequests_review_path(@maintopicmoderatorrequest.maintopic)
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
