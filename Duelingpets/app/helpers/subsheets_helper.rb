module SubsheetsHelper

   private
      def getBookGroups(user)
         groupValue = ""
         age = (currentTime.year - user.birthday.year)
         month = (currentTime.month - user.birthday.month) / 12
         if(month < 0)
            age -= 1
         end

         #Determines the group
         if(age < 7)
            groupValue = 0
         elsif(age < 13)
            groupValue = 1
         elsif(age < 19)
            groupValue = 2
         elsif(age < 25)
            groupValue = 3
         elsif(age < 31)
            groupValue = 4
         elsif(age < 37)
            groupValue = 5
         elsif(age >= 37)
            groupValue = 6
         end
         return groupValue
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         subsheetFound = Subsheet.find_by_id(params[:id])
         if(subsheetFound)
            mainsheetFound = Mainsheet.find_by_id(params[:mainsheet_id])
            if(mainsheetFound && subsheetFound.mainsheet_id == mainsheetFound.id)
               type = ""
               if(subsheetFound.fave_folder)
                  #Favorites to handle
                  allFavorites = subsheetFound.favoritesounds.order("created_on desc")
                  sheetFavorites = allFavorites.select{|favorite| favorite.sound.reviewed && ((!current_user && favorite.sound.bookgroup.name == "Peter Rabbit") || (current_user && favorite.sound.bookgroup_id <= getBookGroups(current_user)))}
                  type = sheetFavorites
               else
                  #Sounds to handle
                  allSounds = subsheetFound.sounds.order("created_on desc")
                  sheetSounds = allSounds.select{|sound| (sound.reviewed && ((!current_user && sound.bookgroup.name == "Peter Rabbit") || (current_user && sound.bookgroup_id <= getBookGroups(current_user)))) || (!sound.reviewed && current_user && ((current_user.id == sound.user_id) || current_user.admin))}
                  type = sheetSounds
               end

               #Defines the owners and guests for favorites and sounds
               guest = (!current_user && type.count > 0 && subsheetFound.bookgroup.name == "Peter Rabbit")
               if(current_user)
                  owner = ((subsheetFound.user_id == current_user.id) || current_user.admin)
                  visitor = (((subsheetFound.bookgroup_id <= getBookGroups(current_user)) && (type.count > 0 || subsheetFound.collab_mode)) && !owner)
                  group = (((subsheetFound.bookgroup_id <= getBookGroups(current_user)) && (type.count == 0 || type.count > 0)) && owner)
               end

               #Checks which user is using the show view
               if((current_user && (group || visitor)) || guest)
                  @subsheet = subsheetFound
                  @mainsheet = mainsheetFound

                  #Sets up the variables dependent on the sheet type
                  if(subsheetFound.fave_folder)
                     @favoritesounds = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  else
                     @sounds = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  end

                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == subsheetFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@subsheet.title} was successfully removed."
                        @subsheet.destroy
                        if(logged_in.admin)
                           redirect_to subsheets_path
                        else
                           redirect_to radiostation_mainsheet_path(mainsheetFound.radiostation, mainsheetFound)
                        end
                     else
                        redirect_to root_path
                     end
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         subsheetFound = Subsheet.find_by_id(params[:id])
         if(subsheetFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == subsheetFound.user_id) || logged_in.admin))
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @subsheet = subsheetFound
               @mainsheet = Mainsheet.find_by_id(@subsheet.mainsheet_id)
               if(type == "update")
                  if(@subsheet.update_attributes(params[:subsheet]))
                     flash[:success] = "#{@subsheet.title} was successfully updated."
                     redirect_to mainsheet_subsheet_path(@subsheet.mainsheet, @subsheet)
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
                  allSubsheets = Subsheet.order("created_on desc")
                  @subsheets = Kaminari.paginate_array(allSubsheets).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               radioMode = Maintenancemode.find_by_id(9)
               if(allMode.maintenance_on || radioMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/radiostations/maintenance"
                  end
               else
                  mainsheetFound = Mainsheet.find_by_id(params[:mainsheet_id])
                  if(mainsheetFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == mainsheetFound.user_id))
                        allGroups = Bookgroup.order("created_on desc")
                        allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                        @group = allowedGroups
                        newSubsheet = mainsheetFound.subsheets.new
                        if(type == "create")
                           newSubsheet = mainsheetFound.subsheets.new(params[:subsheet])
                           newSubsheet.created_on = currentTime
                           newSubsheet.user_id = logged_in.id
                        end
                        @mainsheet = mainsheetFound
                        @subsheet = newSubsheet
                        if(type == "create")
                           if(@subsheet.save)
                              flash[:success] = "#{@subsheet.title} was successfully created."
                              redirect_to mainsheet_subsheet_path(@subsheet.mainsheet, @subsheet)
                           else
                              render "new"
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "edit" || type == "update")
               if(current_user && current_user.admin)
                  editCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  radioMode = Maintenancemode.find_by_id(9)
                  if(allMode.maintenance_on || radioMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/radiostations/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            elsif(type == "show" || type == "destroy")
               if(current_user && current_user.admin)
                  showCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  radioMode = Maintenancemode.find_by_id(9)
                  if(allMode.maintenance_on || radioMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/radiostations/maintenance"
                     end
                  else
                     showCommons(type)
                  end
               end
            end
         end
      end
end
