module ForummoderatorsHelper

   private
      def destroyCommons(type)
         if(type == "destroy")
            modFound = Forummoderator.find_by_id(params[:id])
            if(modFound)
               logged_in = current_user
               if(logged_in && ((logged_in.id == modFound.forum.user_id) || logged_in.admin))
                  @forummoderator = modFound
                  forumFound = Forum.find_by_name(modFound.forum.name)
                  @forum = forumFound
                  @user = userFound
                  flash[:success] = "Moderator was successfully removed."
                  @forummoderator.destroy
                  if(logged_in.admin)
                     redirect_to forummoderators_path
                  elsif(logged_in.id == modFound.forum.user_id)
                     redirect_to forum_forummoderators_modlist(@forum)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Moderator list
            forumFound = Forum.find_by_name(params[:forum_id])
            if(forumFound)
               allMods = forumFound.forummoderators.order("created_on desc")
               @forum = forumFound
               @forummoderators = Kaminari.paginate_array(allMods).page(params[:page]).per(10)
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
            if(type == "index" || type == "unmoderate")
               logged_in = current_user
               if(logged_in)
                  if(type == "index")
                     if(logged_in.admin)
                        allModerators = Forummoderator.order("created_on desc")
                        @forummoderators = Kaminari.paginate_array(allModerators).page(params[:page]).per(10)
                     else
                        redirect_to root_path
                     end
                  else
                     forumFound = Forum.find_by_name(params[:forum_id])
                     if(forumFound)
                        #Check to see if we are a moderator already
                        allMods = forumFound.forummoderators.order("created_on desc")
                        modFound = allMods.select{|moderator| moderator.user_id == logged_in.id}
                        if(modFound.count > 0)
                           #Destroy
                           @forummoderator = Forummoderator.find_by_id(modFound)
                           @forum = forumFound
                           flash[:success] = "You are no longer a moderator."
                           @forummoderator.destroy
                           redirect_to user_forum_path(@forum.user, @forum)
                        else
                           flash[:error] = "You are not a moderator!"
                           redirect_to root_path
                        end
                     else
                        render "start/crazybat"
                     end
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "destroy" || type == "modlist")
               if(current_user && current_user.admin)
                  destroyCommons(type)
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
                     destroyCommons(type)
                  end
               end
            end
         end
      end
end
