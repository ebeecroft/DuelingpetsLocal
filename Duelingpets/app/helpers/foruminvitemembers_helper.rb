module ForuminvitemembersHelper

   private
      def destroyCommons(type)
         if(type == "destroy")
            memberFound = Foruminvitemember.find_by_id(params[:id])
            if(memberFound)
               logged_in = current_user
               if(logged_in && (((logged_in.id == memberFound.forum.user_id) || (logged_in.id == memberFound.user_id)) || logged_in.admin))
                  @foruminvitemember = memberFound
                  userFound = User.find_by_vname(memberFound.forum.user.vname)
                  if(memberFound.user_id == logged_in.id)
                     userFound = User.find_by_vname(memberFound.user.vname)
                  end
                  @user = userFound
                  flash[:success] = "Member was successfully removed."
                  @foruminvitemember.destroy
                  if(logged_in.admin)
                     redirect_to foruminvitemembers_path
                  else
                     redirect_to user_path(@user)
                  end
               else
                  redirect_to root_path
               end
            else
               render "start/crazybat"
            end
         else
            #Member list
            forumFound = Forum.find_by_name(params[:forum_id])
            if(forumFound)
               allMembers = forumFound.foruminvitemembers.order("created_on desc")
               @forum = forumFound
               @user = userFound
               @foruminvitemembers = Kaminari.paginate_array(allMembers).page(params[:page]).per(10)
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
                  allMembers = Foruminvitemember.order("created_on desc")
                  @foruminvitemembers = Kaminari.paginate_array(allMembers).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "destroy" || "memberlist")
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
