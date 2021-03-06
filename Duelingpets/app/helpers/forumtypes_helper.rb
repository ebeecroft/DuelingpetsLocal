module ForumtypesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allTypes = Forumtype.order("created_on desc")
                  @forumtypes = allTypes
               else
                  redirect_to root_path
               end
            end
         end
      end
end
