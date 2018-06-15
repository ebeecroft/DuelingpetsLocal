module ForumtimersHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allTimers = Forumtimer.order("id desc")
                  @forumtimers = Kaminari.paginate_array(allTimers).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
