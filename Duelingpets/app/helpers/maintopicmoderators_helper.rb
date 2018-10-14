module MaintopicmoderatorsHelper

   private
      def destroyCommons(type)
         if(type == "destroy")
            modFound = Maintopicmoderator.find_by_id(params[:id])
            if(modFound)
               logged_in = current_user
               if(logged_in && ((logged_in.id == modFound.maintopic.topiccontainer.forum.user_id) || logged_in.admin))
                  @maintopicmoderator = modFound
                  maintopicFound = Maintopic.find_by_id(modFound.maintopic_id)
                  @maintopic = maintopicFound
                  @user = userFound
                  flash[:success] = "Moderator was successfully removed."
                  @maintopicmoderator.destroy
                  if(logged_in.admin)
                     redirect_to maintopicmoderators_path
                  elsif(logged_in.id == modFound.maintopic.topiccontainer.forum.user_id)
                     redirect_to maintopic_maintopicmoderators_modlist(@maintopic)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Moderator list
            maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
            if(maintopicFound)
               allMods = maintopicFound.maintopicmoderators.order("created_on desc")
               @maintopic = maintopicFound
               @maintopicmoderators = Kaminari.paginate_array(allMods).page(params[:page]).per(10)
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
                        allModerators = Maintopicmoderator.order("created_on desc")
                        @maintopicmoderators = Kaminari.paginate_array(allModerators).page(params[:page]).per(10)
                     else
                        redirect_to root_path
                     end
                  else
                     maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
                     if(maintopicFound)
                        #Check to see if we are a moderator already
                        allMods = maintopicFound.maintopicmoderators.order("created_on desc")
                        modFound = allMods.select{|moderator| moderator.user_id == logged_in.id}
                        if(modFound.count > 0)
                           #Destroy
                           @maintopicmoderator = Maintopicmoderator.find_by_id(modFound)
                           @maintopic = maintopicFound
                           flash[:success] = "You are no longer a moderator."
                           @maintopicmoderator.destroy
                           redirect_to topiccontainer_maintopic_path(@maintopic.topiccontainer, @maintopic)
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
