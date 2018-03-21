module PmsHelper

   private
      def postCount(pm)
         value = pm.pmreplies.count
         return value
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         pmFound = Pm.find_by_id(params[:id])
         if(pmFound)
            if(current_user && ((pmFound.user_id == current_user.id || pmFound.from_user_id == current_user.id) || current_user.admin))
               @user = User.find_by_vname(pmFound.from_user.vname)
               @pm = pmFound
               pmReplies = @pm.pmreplies.order("created_on desc")
               @pmreplies = Kaminari.paginate_array(pmReplies).page(params[:page]).per(10)
               if(pmFound.user_id == current_user.id)
                  @pm.user2_unread = false
                  @pm.save
               elsif(pmFound.from_user_id == current_user.id)
                  @pm.user1_unread = false
                  @pm.save
               end
               if(type == "destroy")
                  logged_in = current_user
                  if(((logged_in.id == pmFound.from_user_id) || (logged_in.id == pmFound.user_id)) || logged_in.admin)
                     @pm.destroy
                     flash[:success] = "#{@pm.title} was successfully removed."
                     if(logged_in.admin)
                        redirect_to pms_path
                     else
                        redirect_to pms_inbox_path
                     end
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         pmFound = Pm.find_by_id(params[:id])
         if(pmFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == pmFound.from_user_id) || logged_in.admin))
               @pm = pmFound
               @user = User.find_by_vname(pmFound.from_user.vname)
               if(type == "update")
                  if(@pm.update_attributes(params[:pm]))
                     flash[:success] = "PM #{@pm.title} was successfully updated."
                     redirect_to user_pm_path(@user, @pm)
                  else
                     render "edit"
                  end
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
                  allPms = Pm.order("created_on desc").page(params[:page]).per(10)
                  @pms = allPms
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
                        newPm = userFound.pms.new
                        if(type == "create")
                           newPm = userFound.pms.new(params[:pm])
                           newPm.from_user_id = logged_in.id
                           newPm.created_on = currentTime
                           newPm.user2_unread = true
                        end
                        @pm = newPm
                        @user = userFound
                        if(type == "create")
                           if(@pm.save)
                              UserMailer.pm_sent(@pm).deliver
                              flash[:success] = "PM #{@pm.title} was successfully created."
                              redirect_to pms_outbox_path
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
               end
            elsif(type == "edit" || type == "update")
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
            elsif(type == "show" || type == "destroy")
               if(current_user && current_user.admin)
                  showCommons(type)
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
                     showCommons(type)
                  end
               end
            elsif(type == "inbox")
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
                     allPms = Pm.order("created_on desc")
                     inbox = allPms.select{|pm| (((pm.from_user_id == logged_in.id) && (pm.pmreplies.count > 0)) || (pm.user_id == logged_in.id))}
                     @user = User.find_by_id(logged_in.id)
                     @pms = Kaminari.paginate_array(inbox).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "outbox")
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
                     allPms = Pm.order("created_on desc")
                     outbox = allPms.select{|pm| pm.from_user_id == logged_in.id}
                     @user = User.find_by_id(logged_in.id)
                     @pms = Kaminari.paginate_array(outbox).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            end
         end
      end
end
