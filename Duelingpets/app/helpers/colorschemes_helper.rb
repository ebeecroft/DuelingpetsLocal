module ColorschemesHelper

   private
      def editCommons(type)
         colorschemeFound = Colorscheme.find_by_name(params[:id])
         if(colorschemeFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == colorschemeFound.user_id) || logged_in.admin))
               @user = User.find_by_vname(colorschemeFound.user.vname)
               @colorscheme = colorschemeFound
               if(type == "update")
                  if(@colorscheme.update_attributes(params[:colorscheme]))
                     flash[:success] = "#{@colorscheme.name} was successfully updated."
                     if(logged_in.admin)
                        redirect_to colorschemes_list_path
                     else
                        redirect_to user_colorschemes_path(colorschemeFound.user)
                     end
                  else
                     render "edit"
                  end
               elsif(type == "destroy")
                  flash[:success] = "#{@colorscheme.name} was successfully removed."
                  #Prior to this destroy all userinfos need to be set to different things
                  allInfos = Userinfo.all
                  infosToChange = allInfos.select{|userinfo| userinfo.colorscheme_id == @colorscheme.id}
                  infosToChange.each do |userinfo|
                     userinfo.colorscheme_id = 1
                     @userinfo = userinfo
                     @userinfo.save
                  end
                  @colorscheme.destroy
                  if(logged_in.admin)
                     redirect_to colorschemes_list_path
                  else
                     redirect_to user_colorschemes_path(colorschemeFound.user)
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def indexCommons
         if(optional)
            userFound = User.find_by_vname(optional)
            if(userFound)
               allColors = userFound.colorschemes.order("created_on desc")
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allColors = Colorscheme.order("created_on desc")
         end
         @colorschemes = Kaminari.paginate_array(allColors).page(params[:page]).per(10)
      end

      def optional
         value = params[:user_id]
         return value
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
                  if(current_user && current_user.admin)
                     indexCommons
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  end
               else
                  indexCommons
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/users/maintenance"
                  end
               else
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if((logged_in && userFound) && (userFound.id == logged_in.id))
                     newColorscheme = logged_in.colorschemes.new
                     if(type == "create")
                        newColorscheme = logged_in.colorschemes.new(params[:colorscheme])
                        newColorscheme.created_on = currentTime
                     end
                     @user = userFound
                     @colorscheme = newColorscheme
                     if(type == "create")
                        if(@colorscheme.save)
                           pointsForColors = 12
                           pouchFound = Pouch.find_by_user_id(logged_in.id)
                           pouchFound.amount += pointsForColors
                           @pouch = pouchFound
                           @pouch.save
                           flash[:success] = "#{@colorscheme.name} was successfully created."
                           redirect_to colorschemes_url
                        else
                           render "new"
                        end
                     end
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "edit" || type == "update" || type == "destroy")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(current_user && current_user.admin)
                     editCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  end
               else
                  editCommons(type)
               end
            elsif(type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allColors = Colorscheme.order("created_on desc")
                  @colorschemes = allColors.page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
