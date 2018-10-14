module SoundvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Soundvisit.find_by_id(params[:id])
               if(visitFound)
                  @soundvisit = visitFound
                  flash[:success] = "Soundvisit was successfully removed."
                  @soundvisit.destroy
                  redirect_to soundvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Soundvisit.order("created_on desc")
               @soundvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
               radioMode = Maintenancemode.find_by_id(9)
               if(allMode.maintenance_on || radioMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/radiostations/maintenance"
                  end
               else
                  soundFound = Sound.find_by_id(params[:sound_id])
                  if(soundFound)
                     soundVisits = soundFound.soundvisits.order("created_on desc")
                     @sound = soundFound
                     @soundvisits = Kaminari.paginate_array(soundVisits).page(params[:page]).per(10)
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
