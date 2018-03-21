module PmrepliesHelper

   private
      def editCommons(type)
         pmreplyFound = Pmreply.find_by_id(params[:id])
         if(pmreplyFound)
            logged_in = current_user
            pmFound = Pm.find_by_id(params[:pm_id])
            if(type == "edit" || type == "update")
               if(logged_in && ((pmreplyFound.user_id == logged_in.id) || logged_in.admin))
                  @pmreply = pmreplyFound
                  @pm = pmFound
                  if(type == "update")
                     if(@pmreply.update_attributes(params[:pmreply]))
                        flash[:success] = "#{@pmreply.user.vname}'s pmreply was successfully updated."
                        redirect_to user_pm_path(@pmreply.pm.from_user, @pmreply.pm)
                     else
                        render "edit"
                     end
                  end
               else
                  redirect_to root_path
               end
            else
               if(logged_in && (pmFound.id == pmreplyFound.pm_id) && ((pmFound.from_user.id == logged_in.id) || (pmFound.user_id == logged_in.id) || logged_in.admin))
                  @pmreply = pmreplyFound
                  @pm = pmFound
                  if(type == "destroy")
                     username = @pmreply.user.vname
                     @pmreply.destroy
                     flash[:success] = "#{username}'s pmreply was successfully removed."
                     if(logged_in.admin)
                        redirect_to pmreplies_path
                     else
                        redirect_to user_pm_path(@pm.from_user, @pm)
                     end
                  end
               else
                  redirect_to root_path
               end
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
                  allPmreplies = Pmreply.order("created_on desc").page(params[:page]).per(10)
                  @pmreplies = allPmreplies
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
                  pmFound = Pm.find_by_id(params[:pm_id])
                  if(pmFound)
                     if(current_user && ((pmFound.user_id == current_user.id) || (pmFound.from_user_id == current_user.id)))
                        logged_in = current_user
                        newPmreply = pmFound.pmreplies.new
                        if(type == "create")
                           newPmreply = pmFound.pmreplies.new(params[:pmreply])
                           newPmreply.user_id = logged_in.id
                           newPmreply.created_on = currentTime
                        end
                        @pm = pmFound
                        @pmreply = newPmreply
                        if(type == "create")
                           if(@pmreply.save)
                              if(pmFound.user_id == current_user.id)
                                 @pm.user1_unread = true
                              else
                                 @pm.user2_unread = true
                              end
                              @pm.save
                              UserMailer.pmreply_sent(@pmreply).deliver
                              flash[:success] = "#{@pmreply.user.vname}'s pmreply was successfully created."
                              redirect_to pms_inbox_path
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
            elsif(type == "edit" || type == "update" || type == "destroy")
               if(current_user && current_user.admin)
                  editCommons(type)
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
                     editCommons(type)
                  end
               end
            end
         end
      end
end
