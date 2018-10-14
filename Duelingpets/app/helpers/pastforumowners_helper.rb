module PastforumownersHelper

   private
      def forumMember(forum)
         #Checks to see if we are not the forumowner
         if(current_user && (forum.user_id != current_user.id))
            allContainers = Topiccontainer.order("created_on desc")
            memberFound = allContainers.select{|topiccontainer| topiccontainer.forum_id == forum.id && topiccontainer.user_id == current_user.id}
            member = false

            #Check to see if the user is actually a member of this forum
            if(memberFound.count == 0)
               allMaintopics = Maintopic.order("created_on desc")
               memberFound = allMaintopics.select{|maintopic| maintopic.topiccontainer.forum_id == forum.id && maintopic.user_id == current_user.id}
               if(memberFound.count == 0)
                  allSubtopics = Subtopic.order("created_on desc")
                  memberFound = allSubtopics.select{|subtopic| subtopic.maintopic.topiccontainer.forum_id == forum.id && subtopic.user_id == current_user.id}
                  if(memberFound.count == 0)
                     allNarratives = Narrative.order("created_on desc")
                     memberFound = allNarratives.select{|narrative| narrative.subtopic.maintopic.topiccontainer.forum_id == forum.id && narrative.user_id == current_user.id}
                     if(memberFound.count > 0)
                        member = true
                     end
                  else
                     member = true
                  end
               else
                  member = true
               end
            else
               member = true
            end
         end
         return member
      end

      def forumModerator(forum)
         moderator = false
         if(current_user && current_user.id != forum.user_id)
            allMods = forum.forummoderators.order("created_on desc")
            modFound = allMods.select{|mod| mod.user_id == current_user.id}
            if(modFound.count == 0)
               allMods = Containermoderator.order("created_on desc")
               modFound = allMods.select{|mod| mod.user_id == current_user.id && mod.topiccontainer.forum_id == forum.id}
               if(modFound.count == 0)
                  allMods = Maintopicmoderator.order("created_on desc")
                  modFound = allMods.select{|mod| mod.user_id == current_user.id && mod.maintopic.topiccontainer.forum_id == forum.id}
                  if(modFound.count > 0)
                     moderator = true
                  end
               else
                  moderator = true
               end
            else
               moderator = true
            end
         end
         return moderator
      end

      def destroyCommons(type)
         if(type == "destroy")
            pastforumownerFound = Pastforumowner.find_by_id(params[:id])
            if(pastforumownerFound)
               logged_in = current_user
               if(logged_in && ((logged_in.id == pastforumownerFound.forum.user_id) || logged_in.admin))
                  @pastforumowner = pastforumownerFound
                  @forum = pastforumownerFound.forum_id
                  flash[:success] = "Pastforumowner was successfully removed."
                  @pastforumowner.destroy
                  if(logged_in.admin)
                     redirect_to pastforumowners_path
                  else
                     redirect_to forum_pastforumowners_forumownerlist_path(@forum)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Forumowner list
            forumFound = Forum.find_by_name(params[:forum_id])
            if(forumFound)
               allForumowners = forumFound.pastforumowners.order("created_on desc")
               @forum = forumFound
               @pastforumowners = Kaminari.paginate_array(allForumowners).page(params[:page]).per(10)
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
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allForumowners = Pastforumowner.order("created_on desc")
                  @pastforumowners = Kaminari.paginate_array(allForumowners).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "destroy" || type == "forumownerlist")
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
            elsif(type == "successor" || type == "takecontrol")
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
                  if(logged_in)
                     forumFound = Forum.find_by_id(params[:forum_id])
                     if(forumFound)
                        newOwner = forumFound.pastforumowners.new(params[:pastforumowner])
                        newOwner.created_on = currentTime
                        newOwner.pastowner_id = forumFound.user.id
                        ownerInactive = false
                        if(logged_in.id == forumFound.user_id)
                           userFound = User.find_by_id(params[:user_id])
                           newOwner.user_id = userFound.id
                           newOwner.status = "Successor"
                        else
                           newOwner.status = "Takecontrol"
                           if(forumFound.forumtype != "Invite")
                              if((currentTime - forumFound.forumtimer.forumowner_last_visited) > 3.months)
                                 if((!forum.forumtimer.moderator_last_visited.nil?) && ((currentTime - getModeraterVisitTime(forum)) < 1.week))
                                    if(forumModerator(forumFound))
                                       newOwner.user_id = logged_in.id
                                       ownerInactive = true
                                    end
                                 else
                                    if((!forumFound.forumtimer.member_last_visited.nil?) && (currentTime - forumFound.forumtimer.member_last_visited) < 4.weeks)
                                       if(forumMember(forumFound) && !forumModerator(forumFound))
                                          newOwner.user_id = logged_in.id
                                          ownerInactive = true
                                       end
                                    else
                                       if(!forumMember(forumFound) && !forumModerator(forumFound))
                                          newOwner.user_id = logged_in.id
                                          ownerInactive = true
                                       end
                                    end
                                 end
                              end
                           else
                              if((currentTime - forumFound.forumtimer.forumowner_last_visited) > 1.month)
                                 member = forumFound.foruminvitemembers.select{|member| member.user_id == logged_in.id}
                                 if(member.count > 0)
                                    if((!forum.forumtimer.moderator_last_visited.nil?) && ((currentTime - getModeraterVisitTime(forum)) < 4.days))
                                       if(moderatorExist(forumFound))
                                          newOwner.user_id = logged_in.id
                                          ownerInactive = true
                                       end
                                    else
                                       if((!forum.forumtimer.member_last_visited.nil?) && ((currentTime - getMemberVisitTime(forum)) < 1.week))
                                          if(memberExist(forumFound) && !forumModerator(forumFound))
                                             newOwner.user_id = logged_in.id
                                             ownerInactive = true
                                          end
                                       else
                                          if(!memberExist(forumFound) && !forumModerator(forumFound))
                                             newOwner.user_id = logged_in.id
                                             ownerInactive = true
                                          end
                                       end
                                    end
                                 end
                              end
                           end
                        end

                        if((newOwner.status == "Takecontrol" && ownerInactive) || newOwner.status == "Successor")
                           @forum = forumFound
                           @pastforumowner = newOwner
                           if(@pastforumowner.save)
                              forumFound.user_id = @pastforumowner.user_id
                              @forum = forumFound
                              @forum.save
                              value = "#{@pastforumowner.to_user.vname} has taken control of the forum #{@pastforumowner.forum.name}."
                              if(@pastforumowner.status == "Successor")
                                 value = "The forumowner #{@pastforumowner.pastowner.vname} has stepped down."
                                 UserMailer.forum_successor(@pastforumowner).deliver
                              else
                                 UserMailer.forum_takecontrol(@pastforumowner).deliver
                              end
                              flash[:success] = value
                              redirect_to user_forum_path(@pastforumowner.forum.user, @pastforumowner.forum)
                           else
                              redirect_to root_path
                           end
                        else
                           redirect_to root_path
                        end
                     else
                        render "start/crazybat"
                     end
                  else
                     redirect_to root_path
                  end
               end
            end
         end
      end
end
