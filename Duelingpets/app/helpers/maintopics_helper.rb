module MaintopicsHelper

   private
      def maintopicContent(maintopic, type)
         value = false
         if(type == "New")
            if((((current_user.id == maintopic.topiccontainer.forum.user_id) || (retrieveForumMod(maintopic.topiccontainer.forum) != 0)) || ((retrieveContainerMod(maintopic.topiccontainer) != 0) || (retrieveMaintopicMod(maintopic) != 0))) || (maintopic.topiccontainer.forum.memberprivilege.name != "Narrative"))
               value = true
            end
         else
            subtopic = maintopic
            if(((current_user.admin || (subtopic.maintopic.topiccontainer.forum.user_id == current_user.id)) || ((retrieveForumMod(subtopic.maintopic.topiccontainer.forum) != 0) || (retrieveContainerMod(subtopic.maintopic.topiccontainer) != 0))) || ((retrieveMaintopicMod(subtopic.maintopic) != 0) || (current_user.id == subtopic.user_id)))
               value = true
            end
         end
         return value
      end

      def getMaintopicMods(maintopic)
         allMods = maintopic.maintopicmoderators.order("created_on desc")
         return allMods.count
      end

      def retrieveMaintopicMod(maintopic)
         allMods = maintopic.maintopicmoderators.order("created_on desc")
         modFound = allMods.select{|mod| mod.user_id == current_user.id}
         return modFound.count
      end

      def getMaintopicSubs(maintopic)
         allSubs = maintopic.maintopicsubscribers.order("created_on desc")
         return allSubs.count
      end

      def retrieveMaintopicSub(maintopic)
         allSubs = maintopic.maintopicsubscribers.order("created_on desc")
         subFound = allSubs.select{|sub| sub.user_id == current_user.id}
         return subFound.count
      end

      def getCurrentNarrative(subtopic)
         narratives = subtopic.narratives.order("created_on desc")
         return narratives
      end

      def visibleSubtopics(topicFound)
         allSubtopics = Subtopic.order("created_on desc")
         maintopicSubs = allSubtopics.select{|subtopic| subtopic.maintopic_id == topicFound.id}
         subtopics = maintopicSubs.select{|subtopic| (subtopic.forumgroup.name == "Rabbit") || (current_user && forumGroupAccess(subtopic.forumgroup, current_user))}
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
         topicFound = Maintopic.find_by_id(params[:id])
         if(topicFound)
            containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
            if(containerFound && topicFound.topiccontainer_id == containerFound.id)
               logged_in = current_user
               if(logged_in)
                  subtopics = visibleSubtopics(topicFound)

                  #Various Moderators
                  allForumMods = Forummoderator.order("created_on desc")
                  modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == topicFound.topiccontainer.forum_id)}
                  if(modFound.count == 0)
                     allContainerMods = Containermoderator.order("created_on desc")
                     modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == topicFound.topiccontainer.forum_id)}
                     if(modFound.count == 0)
                        allMaintopicMods = Maintopicmoderator.order("created_on desc")
                        modFound = allMaintopicMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.maintopic.topiccontainer.forum_id == topicFound.topiccontainer.forum_id)}
                     end
                  end

                  #Sets up variables for staff and members
                  allMembers = Foruminvitemember.order("created_on desc")
                  forumMembers = allMembers.select{|member| (member.forum_id == topicFound.topiccontainer.forum_id)}
                  memberFound = forumMembers.select{|member| (member.user_id == current_user.id)}
                  staff = (((logged_in.admin || (topicFound.topicccontainer.forum.user_id == logged_in.id)) || (modFound.count > 0)))
                  members = ((memberFound.count > 0) && ((topicFound.topiccontainer.forum.memberprivilege.name != "Narrative") || (subtopics.count > 0)))
                  guests = (((topicFound.topiccontainer.forum.memberprivilege.name != "Narrative") || (subtopics.count > 0)))

                  #Determines if we can view the maintopics
                  if(staff || (((topicFound.topiccontainer.forum.forumtype != "Invite") && guests) || (topicFound.topiccontainer.forum.forumtype == "Invite" && members)))
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
                  #Guest viewable
                  subtopics = visibleSubtopics(topicFound)
                  subNars = subtopics.select{|subtopic| subtopic.narratives.count > 0}
                  if(topicFound.topiccontainer.forum.forumtype.name == "Public" && subNars.count > 0)
                     @maintopic = topicFound
                     @subtopics = Kaminari.paginate_array(subNars).page(params[:page]).per(10)
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
         topicFound = Maintopic.find_by_id(params[:id])
         if(topicFound)
            logged_in = current_user
            if(logged_in)
               allForumMods = Forummoderator.order("created_on desc")
               modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == topicFound.topiccontainer.forum_id)}
               if(modFound.count == 0)
                  allContainerMods = Containermoderator.order("created_on desc")
                  modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == topicFound.topiccontainer.forum_id)}
               end
               if((logged_in.admin || (topicFound.topiccontainer.forum.user_id == logged_in.id)) || ((modFound.count > 0) || (logged_in.id == topicFound.user_id)))
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
                     if(logged_in)
                        allForumMods = Forummoderator.order("created_on desc")
                        modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == containerFound.forum_id)}
                        if(modFound.count == 0)
                           allContainerMods = Containermoderator.order("created_on desc")
                           modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == containerFound.forum_id)}
                        end
                        #Only owner, forummod, and containermod can create topics
                        if(((logged_in.id == containerFound.forum.user_id) || (modFound.count > 0)) || (containerFound.forum.memberprivilege.name == "Maintopic"))
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
                                 pointsForMaintopic = 240
                                 ContentMailer.maintopic_created(@maintopic, pointsForMaintopic).deliver
                                 pouch = Pouch.find_by_user_id(@maintopic.user_id)
                                 pouch.amount += pointsForMaintopic
                                 @pouch = pouch
                                 @pouch.save

                                 #Find all the container subs
                                 allContainerSubs = Containersubscriber.all
                                 csubs = allContainerSubs.select{|sub| sub.topiccontainer.id == @maintopic.topiccontainer.id}
                                 if(csubs.count > 0)
                                    csubs.each do |sub|
                                       UserMailer.user_postedmaintopic(@maintopic, sub).deliver
                                    end
                                 end

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
