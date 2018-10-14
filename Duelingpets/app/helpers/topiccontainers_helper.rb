module TopiccontainersHelper

   private
      def topiccontainerContent(topiccontainer, type)
         value = false
         if(type == "New")
            if(((current_user.id == topiccontainer.forum.user_id) || (retrieveForumMod(topiccontainer.forum) != 0)) || ((retrieveContainerMod(topiccontainer) != 0) || (topiccontainer.forum.memberprivilege.name == "Maintopic")))
               value = true
            end
         else
            maintopic = topiccontainer
            if(((current_user.admin || (maintopic.topiccontainer.forum.user_id == current_user.id)) || ((retrieveForumMod(maintopic.topiccontainer.forum) != 0) || (retrieveContainerMod(maintopic.topiccontainer) != 0))) || (current_user.id == maintopic.user_id))
               value = true
            end
         end
         return value
      end

      def getContainerMods(topiccontainer)
         allMods = topiccontainer.containermoderators.order("created_on desc")
         return allMods.count
      end

      def retrieveContainerMod(topiccontainer)
         allMods = topiccontainer.containermoderators.order("created_on desc")
         modFound = allMods.select{|mod| mod.user_id == current_user.id}
         return modFound.count
      end

      def getContainerSubs(topiccontainer)
         allSubs = topiccontainer.containersubscribers.order("created_on desc")
         return allSubs.count
      end

      def retrieveContainerSub(topiccontainer)
         allSubs = topiccontainer.containersubscribers.order("created_on desc")
         subFound = allSubs.select{|sub| sub.user_id == current_user.id}
         return subFound.count
      end

      def getCurrentSubtopic(maintopic)
         subtopics = maintopic.subtopics.order("created_on desc")
         return subtopics
      end

      def visibleMaintopics(containerFound)
         allMaintopics = Maintopic.order("created_on desc")
         containerMaintopics = allMaintopics.select{|maintopic| maintopic.topiccontainer_id == containerFound.id}
         maintopics = containerMaintopics
         return maintopics
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
               logged_in = current_user
               if(logged_in)
                  maintopics = visibleMaintopics(containerFound)

                  #Various Moderators
                  allForumMods = Forummoderator.order("created_on desc")
                  modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == containerFound.forum_id)}
                  if(modFound.count == 0)
                     allContainerMods = Containermoderator.order("created_on desc")
                     modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == containerFound.forum_id)}
                  end

                  #Sets up variables for staff and members
                  allMembers = Foruminvitemember.order("created_on desc")
                  forumMembers = allMembers.select{|member| (member.forum_id == containerFound.forum_id)}
                  memberFound = forumMembers.select{|member| (member.user_id == current_user.id)}
                  staff = (((logged_in.admin || (containerFound.forum.user_id == logged_in.id)) || (modFound.count > 0)))
                  members = ((memberFound.count > 0) && ((containerFound.forum.memberprivilege.name == "Maintopic") || (maintopics.count > 0)))
                  guests = (((containerFound.forum.memberprivilege.name == "Maintopic") || (maintopics.count > 0)))

                  #Determines if we can view the maintopics
                  if(staff || (((containerFound.forum.forumtype != "Invite") && guests) || (containerFound.forum.forumtype == "Invite" && members)))
                     @topiccontainer = containerFound
                     @maintopics = Kaminari.paginate_array(maintopics).page(params[:page]).per(10)
                     if(type == "destroy")
                        logged_in = current_user
                        if(logged_in && ((logged_in.id == containerFound.user_id) || logged_in.admin))
                           flash[:success] = "#{@topiccontainer.title} was successfully removed."
                           @topiccontainer.destroy
                           if(logged_in.admin)
                              redirect_to topiccontainers_path
                           else
                              redirect_to user_forum_path(forumFound.user, forumFound)
                           end
                        else
                           redirect_to root_path
                        end
                     end
                  else
                     redirect_to root_path
                  end
               else
                  #Guest viewable
                  maintopics = visibleMaintopics(containerFound)
                  containerMaintopics = maintopics.select{|maintopic| maintopic.subtopics.count > 0}
                  if(containerFound.forum.forumtype.name == "Public" && containerMaintopics.count > 0)
                     @topiccontainer = containerFound
                     @maintopics = Kaminari.paginate_array(containerMaintopics).page(params[:page]).per(10)
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
         containerFound = Topiccontainer.find_by_id(params[:id])
         if(containerFound)
            logged_in = current_user
            if(logged_in)
               allForumMods = Forummoderator.order("created_on desc")
               modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == containerFound.forum_id)}
               if((logged_in.admin || (containerFound.forum.user_id == logged_in.id)) || ((modFound.count > 0) || (logged_in.id == containerFound.user_id)))
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
                     if(logged_in)
                        allForumMods = Forummoderator.order("created_on desc")
                        modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == forumFound.id)}
                        #Only owner, forummod, and containermod can create topics
                        if(((logged_in.id == forumFound.user_id) || (modFound.count > 0)))
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
