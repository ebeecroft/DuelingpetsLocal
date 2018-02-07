module MaintopicsHelper

   private
      def getCurrentNarrative(subtopic)
         narratives = subtopic.narratives.order("created_on desc")
         return narratives
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         topicFound = Maintopic.find_by_id(params[:id])
         if(topicFound)
            containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
            if(containerFound && topicFound.topiccontainer_id == containerFound.id)
               maintopicSubtopics = topicFound.subtopics.order("created_on desc")
               subtopics = maintopicSubtopics.select{|subtopic| (subtopic.narratives.count > 0 && subtopic.forumgroup.name == "Rabbit") || (current_user && (forumGroupAccess(subtopic.forumgroup, current_user) && ((((subtopic.maintopic.topiccontainer.forum.memberprivilege.name == "Subtopic") || (subtopic.maintopic.topiccontainer.forum.memberprivilege.name == "Maintopic")) || ((current_user.id == subtopic.maintopic.topiccontainer.forum.user_id) || current_user.admin)))))}
               if((topicFound.topiccontainer.forum.forumtype == "Public" && (subtopics.count > 0 || (current_user && current_user.id == topicFound.topiccontainer.forum.user_id))) || current_user && ((topicFound.topiccontainer.forum.forumtype.name == "Invite" && current_user.id == topicFound.topiccontainer.forum.user_id) || (topicFound.topiccontainer.forum.forumtype.name == "Private" && (subtopics.count > 0 || (current_user.id == topicFound.topiccontainer.forum.user_id)))))
                  @maintopic = topicFound
                  @subtopics = Kaminari.paginate_array(subtopics).page(params[:page]).per(10)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == topicFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@maintopic.title} was successfully removed."
                        @maintopic.destroy
                        if(logged_in.admin)
                           redirect_to maintopics_path
                        else
                           redirect_to forum_topiccontainer_path(containerFound.forum, containerFound)
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
         topicFound = Maintopic.find_by_id(params[:id])
         if(topicFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == topicFound.user_id) || logged_in.admin))
               @maintopic = topicFound
               @topiccontainer = Topiccontainer.find_by_id(topicFound.topiccontainer_id)
               if(type == "update")
                  if(@maintopic.update_attributes(params[:maintopic]))
                     flash[:success] = "#{@maintopic.title} was successfully updated."
                     redirect_to topiccontainer_maintopic_path(@maintopic.topiccontainer, @maintopic)
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
                  allTopics = Maintopic.order("created_on desc")
                  @maintopics = Kaminari.paginate_array(allTopics).page(params[:page]).per(10)
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
                     if(logged_in && (logged_in.id == containerFound.forum.user_id) || containerFound.forum.memberprivilege.name == "Maintopic")
                        newTopic = containerFound.maintopics.new
                        if(type == "create")
                           newTopic = containerFound.maintopics.new(params[:maintopic])
                           newTopic.created_on = currentTime
                           newTopic.user_id = logged_in.id
                        end
                        @topiccontainer = containerFound
                        @maintopic = newTopic
                        if(type == "create")
                           if(@maintopic.save)
                              pointsForMaintopic = 220
                              pouch = Pouch.find_by_user_id(@maintopic.user_id)
                              pouch.amount += pointsForMaintopic
                              @pouch = pouch
                              @pouch.save
                              ContentMailer.maintopic_created(@maintopic, pointsForMaintopic).deliver
                              flash[:success] = "#{@maintopic.title} was successfully created."
                              redirect_to topiccontainer_maintopic_path(@maintopic.topiccontainer, @maintopic)
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
