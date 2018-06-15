module UservisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Uservisit.find_by_id(params[:id])
               if(visitFound)
                  @uservisit = visitFound
                  flash[:success] = "Uservisit was successfully removed."
                  @uservisit.destroy
                  redirect_to uservisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Uservisit.order("created_on desc")
               @uservisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/users/maintenance"
                  end
               else
                  userFound = User.find_by_vname(params[:user_id])
                  if(userFound)
                     userVisits = userFound.uservisits.order("created_on desc")
                     @user = userFound
                     @uservisits = Kaminari.paginate_array(userVisits).page(params[:page]).per(10) 
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
