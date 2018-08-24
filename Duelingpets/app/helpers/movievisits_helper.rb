module MovievisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Movievisit.find_by_id(params[:id])
               if(visitFound)
                  @movievisit = visitFound
                  flash[:success] = "Movievisit was successfully removed."
                  @movievisit.destroy
                  redirect_to movievisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Movievisit.order("created_on desc")
               @movievisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
               channelMode = Maintenancemode.find_by_id(7)
               if(allMode.maintenance_on || channelMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/channels/maintenance"
                  end
               else
                  movieFound = Movie.find_by_id(params[:movie_id])
                  if(movieFound)
                     movieVisits = movieFound.movievisits.order("created_on desc")
                     @movie = movieFound
                     @movievisits = Kaminari.paginate_array(movieVisits).page(params[:page]).per(10)
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
