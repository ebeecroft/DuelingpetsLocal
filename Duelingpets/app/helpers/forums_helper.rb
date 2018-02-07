module ForumsHelper

   private
      def getForumMakeup(forum, type)
         forumcontainers = forum.topiccontainers
         mainValue = 0
         subValue = 0
         narValue = 0
         containersMaintopic = forumcontainers.select{|topiccontainer| topiccontainer.maintopics.count > 0}
         containersMaintopic.each do |container|
            container.maintopics.each do |maintopic|
               mainValue = mainValue + 1
               maintopic.subtopics.each do |subtopic|
                  subValue = subValue + 1
                  subtopic.narratives.each do |narrative|
                     narValue = narValue + 1
                  end
               end
            end
         end
         if(type == "Container")
            value = forumcontainers.count
         elsif(type == "Maintopic")
            value = mainValue
         elsif(type == "Subtopic")
            value = subValue
         elsif(type == "Narrative")
            value = narValue
         end
         return value
      end

      def getForumPrivilege(forum, user)
         forumFound = Forum.find_by_id(forum.id)
         if(forumFound)
            if(forumFound.user_id == user.id)
               value = "+"
            else
               value = "~"
            end
         else
            value = "~"
         end
         return value
      end

      def musicCommons(type)
         forumFound = Forum.find_by_id(params[:id])
         if(forumFound)
            if(type == "gmusiccontrol")
               music_value = ""
               if(checkMusicFlag == "On")
                  music_value = "Off"
               else
                  music_value = "On"
               end
               cookies[:music_on] = {:value => music_value}
               @forum = forumFound
               redirect_to user_forum_path(@forum.user, @forum)
            else
               if(current_user && current_user.id == forumFound.user_id)
                  if(forumFound.music_on)
                     forumFound.music_on = false
                  else
                     forumFound.music_on = true
                  end
                  @forum = forumFound
                  @forum.save
                  redirect_to user_forum_path(@forum.user, @forum)
               end
            end
         else
            render "start/crazybat"
         end
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         forumFound = Forum.find_by_name(params[:id])
         if(forumFound)
            userFound = User.find_by_vname(params[:user_id])
            if(userFound && forumFound.user_id == userFound.id)
               forumTopicContainers = forumFound.topiccontainers.order("id asc")
               containers = forumTopicContainers.select{|container| container.maintopics.count > 0 || (current_user && ((current_user.id == container.user_id) || (current_user.id == container.forum.user_id)) || current_user.admin)}
               if((forumFound.forumtype.name == "Public" && (containers.count > 0 || (current_user && current_user.id == forumFound.user_id))) || current_user && ((forumFound.forumtype.name == "Invite" && current_user.id == forumFound.user_id) || (forumFound.forumtype.name == "Private" && (containers.count > 0 || (current_user.id == forumFound.user_id)))))
                  @forum = forumFound
                  @topiccontainers = Kaminari.paginate_array(containers).page(params[:page]).per(10)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == forumFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@forum.name} was successfully removed."
                        @forum.destroy
                        if(logged_in.admin)
                           redirect_to forums_list_path
                        else
                           redirect_to user_forums_path(forumFound.user)
                        end
                     else
                        redirect_to root_path
                     end
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         forumFound = Forum.find_by_name(params[:id])
         if(forumFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == forumFound.user_id) || logged_in.admin))
               @forum = forumFound
               @user = User.find_by_vname(forumFound.user.vname)
               @type = Forumtype.all
               @privilege = Memberprivilege.all
               if(type == "update")
                  if(@forum.update_attributes(params[:forum]))
                     flash[:success] = "#{@forum.name} was successfully updated."
                     redirect_to user_forum_path(@user, @forum)
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

      def optional
         value = params[:user_id]
         return value
      end

      def indexCommons
         if(optional)
            userFound = User.find_by_vname(optional)
            if(userFound)
               allForums = userFound.forums.order("created_on desc")
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allForums = Forum.order("created_on desc")
         end
         allForums.select{|forum| (forum.forumtype.name == "Public" && (forum.topiccontainers.count > 0 || (current_user && (current_user.id == forum.user_id) || current_user.admin))) || (current_user && (forum.forumtype.name == "Private" && (forum.topiccontainers.count > 0 || (current_user && (current_user.id == forum.user_id) || current_user.admin))) || (forum.forumtype.name == "Invite" && ((current_user.id == forum.user_id) || current_user.admin)))}
         @forums = Kaminari.paginate_array(allForums).page(params[:page]).per(10)
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               if(current_user && current_user.admin)
                  indexCommons
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
                     indexCommons
                  end
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
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newForum = logged_in.forums.new
                        if(type == "create")
                           newForum = logged_in.forums.new(params[:forum])
                           newForum.created_on = currentTime
                        end
                        @type = Forumtype.all
                        @privilege = Memberprivilege.all
                        @user = userFound
                        @forum = newForum
                        if(type == "create")
                           if(@forum.save)
                              flash[:success] = "#{@forum.name} was successfully created."
                              redirect_to user_forum_path(@user, @forum)
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
                  forumMode = Maintenancemode.find_by_id(10)
                  if(allMode.maintenance_on || forumMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/forums/maintenance"
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
                  forumMode = Maintenancemode.find_by_id(10)
                  if(allMode.maintenance_on || forumMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/forums/maintenance"
                     end
                  else
                     showCommons(type)
                  end
               end
            elsif(type == "musiccontrol" || "gmusiccontrol")
               allMode = Maintenancemode.find_by_id(1)
               forumMode = Maintenancemode.find_by_id(10)
               if(allMode.maintenance_on || forumMode.maintenance_on)
                  if(current_user && current_user.admin)
                     musicCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/forums/maintenance"
                     end
                  end
               else
                  musicCommons(type)
               end
            elsif(type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allForums = Forum.order("created_on desc")
                  @forums = Kaminari.paginate_array(allForums).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
