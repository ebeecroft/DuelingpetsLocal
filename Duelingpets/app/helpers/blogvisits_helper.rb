module BlogvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Blogvisit.find_by_id(params[:id])
               if(visitFound)
                  @blogvisit = visitFound
                  flash[:success] = "Blogvisit was successfully removed."
                  @blogvisit.destroy
                  redirect_to blogvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Blogvisit.order("created_on desc")
               @blogvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
            end
         else
            redirect_to root_path
         end
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               allMode = Maintenancemode.find_by_id(1)
               blogMode = Maintenancemode.find_by_id(6)
               if(allMode.maintenance_on || blogMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/blogs/maintenance"
                  end
               else
                  blogFound = Blog.find_by_id(params[:blog_id])
                  if(blogFound)
                     blogVisits = blogFound.blogvisits.order("created_on desc")
                     @blog = blogFound
                     @blogvisits = Kaminari.paginate_array(blogVisits).page(params[:page]).per(10)
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy" || type == "visitlist")
               destroyCommons(type)
            end
         end
      end
end
