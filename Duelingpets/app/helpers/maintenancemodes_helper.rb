module MaintenancemodesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            logged_in = current_user
            if(logged_in && logged_in.admin)
               if(type == "index")
                  allModes = Maintenancemode.order("id").page(params[:page]).per(10)
                  @maintenancemodes = allModes
               elsif(type == "new" || type == "create")
                  newMaintenancemode = Maintenancemode.new
                  if(type == "create")
                     newMaintenancemode = Maintenancemode.new(params[:maintenancemode])
                     newMaintenancemode.created_on = currentTime
                  end
                  @maintenancemode = newMaintenancemode
                  if(type == "create")
                     if(@maintenancemode.save)
                        flash[:success] = "#{@maintenancemode.name} was successfully created."
                        redirect_to maintenancemodes_url
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update")
                  maintenancemodeFound = Maintenancemode.find_by_id(params[:id])
                  if(maintenancemodeFound)
                     @maintenancemode = maintenancemodeFound
                     if(type == "update")
                        if(@maintenancemode.update_attributes(params[:maintenancemode]))
                           flash[:success] = "#{@maintenancemode.name} was successfully updated."
                           redirect_to maintenancemodes_url
                        else
                           render "edit"
                        end
                     end
                  else
                     render "start/crazybat"
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
