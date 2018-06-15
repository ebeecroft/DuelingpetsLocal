module SubtopicsHelper

   private
      def forumGroupAccess(forumgroup, logged_in)
         value = false
         if(forumgroup.name == "RabbitOnly" && getBookGroups(logged_in) == 1)
            value = true
         elsif(forumgroup.name == "BluelandOnly" && getBookGroups(logged_in) == 2)
            value = true
         elsif(forumgroup.name == "DragonOnly" && getBookGroups(logged_in) == 3)
            value = true
         elsif(forumgroup.name == "Rabbit" && getBookGroups(logged_in) >= 1)
            value = true
         elsif(forumgroup.name == "Blueland" && getBookGroups(logged_in) >= 2)
            value = true
         elsif(forumgroup.name == "Dragon" && getBookGroups(logged_in) >= 3)
            value = true
         elsif(forumgroup.name == "Silverwing" && getBookGroups(logged_in) >= 4)
            value = true
         elsif(forumgroup.name == "Harahpin" && getBookGroups(logged_in) >= 5)
            value = true
         elsif(forumgroup.name == "LOTR" && getBookGroups(logged_in) == 6)
            value = true
         end
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
         subtopicFound = Subtopic.find_by_id(params[:id])
         if(subtopicFound)
            maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
            if(maintopicFound && subtopicFound.maintopic_id == maintopicFound.id)
               #Finds the narratives based on the user's forumgroup
               subNars = subtopicFound.narratives.order("created_on desc")
               narratives = subNars.select{|narrative| narrative.forumgroup.name == "Rabbit" || (current_user && forumGroupAccess(narrative.forumgroup, current_user))}
               #Determines if we are a guest or not
               if(current_user)
                  allForumMembers = Foruminvitemember.order("created_on desc")
                  memberMatch = allForumMembers.select{|member| member.user_id == current_user.id && member.forum_id == subtopicFound.maintopic.topiccontainer.forum_id}
                  #Determines if we are looking at an invite forum or a noninvite forum
                  if((subtopicFound.maintopic.topiccontainer.forum.forumtype != "Invite" && forumGroupAccess(subtopicFound.forumgroup, current_user)) || ((subtopicFound.maintopic.topiccontainer.forum.forumtype == "Invite" && forumGroupAccess(subtopicFound.forumgroup, current_user)) && ((subtopicFound.maintopic.topiccontainer.forum.user_id == current_user.id) || memberMatch.count > 0)))
                     @subtopic = subtopicFound
                     @narratives = Kaminari.paginate_array(narratives).page(params[:page]).per(10)
                     if(type == "destroy")
                        logged_in = current_user
                        if(logged_in && (((logged_in.id == subtopicFound.user_id) || (subtopicFound.maintopic.topiccontainer.forum.user_id ==  logged_in.id)) || logged_in.admin))
                           flash[:success] = "#{@subtopic.title} was successfully removed."
                           @subtopic.destroy
                           if(logged_in.admin)
                              redirect_to subtopics_path
                           else
                              redirect_to topiccontainer_maintopic_path(maintopicFound.topiccontainer, maintopicFound)
                           end
                        else
                           redirect_to root_path
                        end
                     end
                  else
                     redirect_to root_path
                  end
               else
                  if((subtopicFound.maintopic.topiccontainer.forum.forumtype == "Public" && subtopicFound.forumgroup.name == "Rabbit") && narratives.count > 0)
                     @subtopic = subtopicFound
                     @narratives = Kaminari.paginate_array(narratives).page(params[:page]).per(10)
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
         subtopicFound = Subtopic.find_by_id(params[:id])
         if(subtopicFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == subtopicFound.user_id) || logged_in.admin))
               allGroups = Forumgroup.all
               allowedGroups = allGroups.select{|forumgroup| forumGroupAccess(forumgroup, logged_in)}
               @group = allowedGroups
               @subtopic = subtopicFound
               @maintopic = Maintopic.find_by_id(subtopicFound.maintopic_id)
               if(type == "update")
                  if(@subtopic.update_attributes(params[:subtopic]))
                     flash[:success] = "#{@subtopic.title} was successfully updated."
                     redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
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
                  allTopics = Subtopic.order("created_on desc")
                  @subtopics = Kaminari.paginate_array(allTopics).page(params[:page]).per(10)
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
                     if(logged_in && (logged_in.id == maintopicFound.topiccontainer.forum.user_id) || (maintopicFound.topiccontainer.forum.memberprilivege.name == "Subtopic" || maintopicFound.topiccontainer.forum.memberprivileges.name == "Maintopic"))
                        newTopic = maintopicFound.subtopics.new
                        if(type == "create")
                           newTopic = maintopicFound.subtopics.new(params[:subtopic])
                           newTopic.created_on = currentTime
                           newTopic.user_id = logged_in.id
                        end
                        allGroups = Forumgroup.all
                        allowedGroups = allGroups.select{|forumgroup| forumGroupAccess(forumgroup, logged_in)}
                        @group = allowedGroups
                        @maintopic = maintopicFound
                        @subtopic = newTopic
                        if(type == "create")
                           if(@subtopic.save)
                              pointsForSubtopic = 120
                              pouch = Pouch.find_by_user_id(@subtopic.user_id)
                              pouch.amount += pointsForSubtopic
                              @pouch = pouch
                              @pouch.save
                              ContentMailer.subtopic_created(@subtopic, pointsForSubtopic).deliver
                              flash[:success] = "#{@subtopic.title} was successfully created."
                              redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
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
