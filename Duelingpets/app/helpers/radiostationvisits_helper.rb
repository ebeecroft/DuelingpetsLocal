module RadiostationvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Radiostationvisit.find_by_id(params[:id])
               if(visitFound)
                  @radiostationvisit = visitFound
                  flash[:success] = "Radiostationvisit was successfully removed."
                  @radiostationvisit.destroy
                  redirect_to radiostationvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Radiostationvisit.order("created_on desc")
               @radiostationvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
                  radioFound = Radiostation.find_by_name(params[:radiostation_id])
                  if(radioFound)
                     radioVisits = radioFound.radiostationvisits.order("created_on desc")
                     @radiostation = radioFound
                     @radiostationvisits = Kaminari.paginate_array(radioVisits).page(params[:page]).per(10)
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
