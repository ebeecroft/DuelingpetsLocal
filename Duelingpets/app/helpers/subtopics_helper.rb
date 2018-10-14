module SubtopicsHelper

   private
      def subtopicContent(subtopic, type)
         value = false
         if(type == "New")
            if(current_user)
               value = true
            end
         else
            narrative = subtopic
            if(((current_user.admin || (narrative.subtopic.maintopic.topiccontainer.forum.user_id == current_user.id)) || ((retrieveForumMod(narrative.subtopic.maintopic.topiccontainer.forum) != 0) || (retrieveContainerMod(narrative.subtopic.maintopic.topiccontainer) != 0))) || ((retrieveMaintopicMod(narrative.subtopic.maintopic) != 0) || (current_user.id == narrative.user_id)))
               value = true
            end
         end
         return value
      end

      def getSubtopicSubs(subtopic)
         allSubs = subtopic.subtopicsubscribers.order("created_on desc")
         return allSubs.count
      end

      def retrieveSubtopicSub(subtopic)
         allSubs = subtopic.subtopicsubscribers.order("created_on desc")
         subFound = allSubs.select{|sub| sub.user_id == current_user.id}
         return subFound.count
      end

      def visibleNarratives(topicFound)
         allNarratives = Narrative.order("created_on desc")
         subNars = allNarratives.select{|narrative| narrative.subtopic_id == topicFound.id}
         narratives = subNars.select{|narrative| (narrative.forumgroup.name == "Rabbit") || (current_user && forumGroupAccess(narrative.forumgroup, current_user))}
         return narratives
      end

      def subtopicViewable(topicFound)
         value = false
         if((topicFound.forumgroup.name == "Rabbit") || (current_user && forumGroupAccess(topicFound.forumgroup, current_user)))
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
            subtopicViewable = subtopicViewable(subtopicFound)
            if((maintopicFound && (subtopicFound.maintopic_id == maintopicFound.id)) && subtopicViewable)
               logged_in = current_user
               if(logged_in)
                  narratives = visibleNarratives(subtopicFound)

                  #Various Moderators
                  allForumMods = Forummoderator.order("created_on desc")
                  modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                  if(modFound.count == 0)
                     allContainerMods = Containermoderator.order("created_on desc")
                     modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                     if(modFound.count == 0)
                        allMaintopicMods = Maintopicmoderator.order("created_on desc")
                        modFound = allMaintopicMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.maintopic.topiccontainer.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                     end
                  end

                  #Sets up variables for staff and members
                  allMembers = Foruminvitemember.order("created_on desc")
                  forumMembers = allMembers.select{|member| (member.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                  memberFound = forumMembers.select{|member| (member.user_id == current_user.id)}
                  staff = (((logged_in.admin || (subtopicFound.maintopic.topicccontainer.forum.user_id == logged_in.id)) || (modFound.count > 0)))
                  members = (memberFound.count > 0)

                  #Determines if we can view the maintopics
                  if(staff || ((subtopicFound.maintopic.topiccontainer.forum.forumtype != "Invite") || (subtopicFound.maintopic.topiccontainer.forum.forumtype == "Invite" && members)))
                     @subtopic = subtopicFound
                     @narratives = Kaminari.paginate_array(narratives).page(params[:page]).per(10)
                     if(type == "destroy")
                        logged_in = current_user
                        if(logged_in && ((logged_in.id == subtopicFound.user_id) || logged_in.admin))
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
                  #Guest viewable
                  narratives = visibleNarratives(subtopicFound)
                  if(subtopicFound.maintopic.topiccontainer.forum.forumtype.name == "Public" && narratives.count > 0)
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
            if(logged_in)
               allForumMods = Forummoderator.order("created_on desc")
               modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
               if(modFound.count == 0)
                  allContainerMods = Containermoderator.order("created_on desc")
                  modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                  if(modFound.count == 0)
                     allMaintopicMods = Maintopicmoderator.order("created_on desc")
                     modFound = allMaintopicMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.maintopic.topiccontainer.forum_id == subtopicFound.maintopic.topiccontainer.forum_id)}
                  end
               end
               if((logged_in.admin || (subtopicFound.maintopic.topiccontainer.forum.user_id == logged_in.id)) || ((modFound.count > 0) || (logged_in.id == subtopicFound.user_id)))
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
                     if(logged_in)
                        allForumMods = Forummoderator.order("created_on desc")
                        modFound = allForumMods.select{|moderator| (moderator.user_id == logged_in.id) && (moderator.forum_id == maintopicFound.topiccontainer.forum_id)}
                        if(modFound.count == 0)
                           allContainerMods = Containermoderator.order("created_on desc")
                           modFound = allContainerMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.topiccontainer.forum_id == maintopicFound.topiccontainer.forum_id)}
                           if(modFound.count == 0)
                              allMaintopicMods = Maintopicmoderator.order("created_on desc")
                              modFound = allMaintopicMods.select{|moderator| moderator.user_id == logged_in.id && (moderator.maintopic.topiccontainer.forum_id == maintopicFound.topiccontainer.forum_id)}
                           end
                        end
                        #Only owner, forummod, and containermod can create topics
                        if(((logged_in.id == maintopicFound.topiccontainer.forum.user_id) || (modFound.count > 0)) || (maintopicFound.topiccontainer.forum.memberprivilege.name != "Narrative"))
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
                                 pointsForSubtopic = 80
                                 ContentMailer.subtopic_created(@subtopic, pointsForSubtopic).deliver
                                 pouch = Pouch.find_by_user_id(@subtopic.user_id)
                                 pouch.amount += pointsForSubtopic
                                 @pouch = pouch
                                 @pouch.save

                                 #Find all the container subs
                                 allContainerSubs = Containersubscriber.all
                                 csubs = allContainerSubs.select{|sub| sub.topiccontainer.id == @subtopic.maintopic.topiccontainer.id}
                                 if(csubs.count > 0)
                                    csubs.each do |sub|
                                       UserMailer.user_postedsubtopic(@subtopic, sub).deliver
                                    end
                                 end

                                 #Find all the maintopic subs
                                 allMaintopicSubs = Maintopicsubscriber.all
                                 mainsubs = allMaintopicSubs.select{|sub| sub.maintopic.id == @subtopic.maintopic.id}
                                 if(mainsubs.count > 0)
                                    mainsubs.each do |sub|
                                       UserMailer.user_postedsubtopic(@subtopic, sub).deliver
                                    end
                                 end

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
