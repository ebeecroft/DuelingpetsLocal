module TopiccontainersHelper

   private
      def getCurrentSubtopic(maintopic)
         subtopics = maintopic.subtopics.order("created_on desc")
         return subtopics
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         containerFound = Topiccontainer.find_by_id(params[:id])
         if(containerFound)
            forumFound = Forum.find_by_name(params[:forum_id])
            if(forumFound && containerFound.forum_id == forumFound.id)
               containerMaintopics = containerFound.maintopics.order("created_on desc")
               maintopics = containerMaintopics.select{|maintopic| maintopic.subtopics.count > 0 || (current_user && (((maintopic.topiccontainer.forum.memberprivilege.name == "Subtopic") || (maintopic.topiccontainer.forum.memberprivilege.name == "Maintopic")) || ((current_user.id == maintopic.topiccontainer.forum.user_id) || current_user.admin)))}
               if((containerFound.forum.forumtype == "Public" && (maintopics.count > 0 || (current_user && current_user.id == containerFound.forum.user_id))) || current_user && ((containerFound.forum.forumtype.name == "Invite" && current_user.id == containerFound.forum.user_id) || (containerFound.forum.forumtype.name == "Private" && (maintopics.count > 0 || (current_user.id == containerFound.forum.user_id)))))
                  @topiccontainer = containerFound
                  #Only if there is one topic container per forum
                  forumFound = Forum.find_by_id(@topiccontainer.forum_id)
                  @maintopics = Kaminari.paginate_array(maintopics).page(params[:page]).per(10)
                  if(forumFound.topiccontainers.count > 1)
                     @maintopics = Kaminari.paginate_array(maintopics).page(params[:page]).per(5)
                  end
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == containerFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@topiccontainer.title} was successfully removed."
                        @topiccontainer.destroy
                        if(logged_in.admin)
                           redirect_to topiccontainers_path
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
         containerFound = Topiccontainer.find_by_id(params[:id])
         if(containerFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == containerFound.user_id) || logged_in.admin))
               @topiccontainer = containerFound
               @forum = Forum.find_by_id(containerFound.forum_id)
               if(type == "update")
                  if(@topiccontainer.update_attributes(params[:topiccontainer]))
                     flash[:success] = "#{@topiccontainer.title} was successfully updated."
                     redirect_to forum_topiccontainer_path(@topiccontainer.forum, @topiccontainer)
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
                  allContainers = Topiccontainer.order("created_on desc")
                  @topiccontainers = Kaminari.paginate_array(allContainers).page(params[:page]).per(10)
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
                     if(logged_in && (logged_in.id == forumFound.user_id))
                        newContainer = forumFound.topiccontainers.new
                        if(type == "create")
                           newContainer = forumFound.topiccontainers.new(params[:topiccontainer])
                           newContainer.created_on = currentTime
                           newContainer.user_id = logged_in.id
                        end
                        @forum = forumFound
                        @topiccontainer = newContainer
                        if(type == "create")
                           if(@topiccontainer.save)
                              pointsForContainer = 380
                              pouch = Pouch.find_by_user_id(@topiccontainer.user_id)
                              pouch.amount += pointsForContainer
                              @pouch = pouch
                              @pouch.save
                              ContentMailer.topiccontainer_created(@topiccontainer, pointsForContainer).deliver
                              flash[:success] = "#{@topiccontainer.title} was successfully created."
                              redirect_to forum_topiccontainer_path(@topiccontainer.forum, @topiccontainer)
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
            end
         end
      end
end
