module ForumgroupsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allGroups = Forumgroup.order("created_on desc")
                  @forumgroups = allGroups
               else
                  redirect_to root_path
               end
            end
         end
      end
end
