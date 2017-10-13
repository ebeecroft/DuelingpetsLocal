module UserinfosHelper

   private
      def editCommons(type)
         infoFound =  Userinfo.find_by_id(params[:id])
         if(infoFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == infoFound.user_id) || logged_in.admin))
               @userinfo = infoFound
                  allColors = Colorscheme.all
                  activatedColors = allColors.select{|colorscheme| colorscheme.activate || ((colorscheme.user_id == logged_in.id) || logged_in.admin)}
               @colorschemes = activatedColors
               if(type == "update")
                  if(@userinfo.update_attributes(params[:userinfo]))
                     flash[:success] = "Userinfo for #{@userinfo.user.vname} was successfully updated."
                     redirect_to @userinfo.user
                  else
                     render "edit"
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
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
                  allInfos = Userinfo.order("id desc").page(params[:page]).per(10)
                  @userinfos = allInfos
               else
                  redirect_to root_path
               end
            elsif(type == "edit" || type == "update")
               if(current_user && current_user.admin)
                  editCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  userMode = Maintenancemode.find_by_id(5)
                  if(allMode.maintenance_on || userMode.maintenance_on)
                     if(allMode.maintenance_on)
                        #the render section
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            end
         end
      end
end
