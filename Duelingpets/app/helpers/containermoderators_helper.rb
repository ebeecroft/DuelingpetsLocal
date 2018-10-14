module ContainermoderatorsHelper

   private
      def destroyCommons(type)
         if(type == "destroy")
            modFound = Containermoderator.find_by_id(params[:id])
            if(modFound)
               logged_in = current_user
               if(logged_in && ((logged_in.id == modFound.topiccontainer.forum.user_id) || logged_in.admin))
                  @containermoderator = modFound
                  containerFound = Topiccontainer.find_by_id(modFound.topiccontainer_id)
                  @topiccontainer = containerFound
                  @user = userFound
                  flash[:success] = "Moderator was successfully removed."
                  @containermoderator.destroy
                  if(logged_in.admin)
                     redirect_to containermoderators_path
                  elsif(logged_in.id == modFound.topiccontainer.forum.user_id)
                     redirect_to topiccontainer_containermoderators_modlist(@topiccontainer)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Moderator list
            containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
            if(containerFound)
               allMods = containerFound.containermoderators.order("created_on desc")
               @topiccontainer = containerFound
               @containermoderators = Kaminari.paginate_array(allMods).page(params[:page]).per(10)
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
                        allModerators = Containermoderator.order("created_on desc")
                        @containermoderators = Kaminari.paginate_array(allModerators).page(params[:page]).per(10)
                     else
                        redirect_to root_path
                     end
                  else
                     containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
                     if(containerFound)
                        #Check to see if we are a moderator already
                        allMods = containerFound.containermoderators.order("created_on desc")
                        modFound = allMods.select{|moderator| moderator.user_id == logged_in.id}
                        if(modFound.count > 0)
                           #Destroy
                           @containermoderator = Containermoderator.find_by_id(modFound)
                           @topiccontainer = containerFound
                           flash[:success] = "You are no longer a moderator."
                           @containermoderator.destroy
                           redirect_to forum_topiccontainer_path(@topiccontainer.forum, @topiccontainer)
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
