module MainsheetsHelper

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

      def getSheetSounds(subsheet, type)
         value = ""
         if(type == "Array")
            #Favorites to handle
            allFavorites = subsheet.order("created_on desc")
            sheetFavorites = allFavorites.select{|favorite| favorite.sound.reviewed && ((!current_user && favorite.sound.bookgroup.name == "Peter Rabbit") || (current_user && favorite.sound.bookgroup_id <= getBookGroups(current_user)))}
            favorite = sheetFavorites.first
            value = favorite
         elsif(type == "Count")
            if(subsheet.fave_folder)
               #Favorites count
               allFavorites = subsheet.favoritesounds.order("created_on desc")
               sheetFavorites = allFavorites.select{|favorite| favorite.sound.reviewed && ((!current_user && favorite.sound.bookgroup.name == "Peter Rabbit") || (current_user && favorite.sound.bookgroup_id <= getBookGroups(current_user)))}
               value = sheetFavorites.count
            else
               #Sounds count
               allSounds = subsheet.sounds.order("created_on desc")
               sheetSounds = allSounds.select{|sound| (sound.reviewed && ((!current_user && sound.bookgroup.name == "Peter Rabbit") || (current_user && sound.bookgroup_id <= getBookGroups(current_user)))) || (!sound.reviewed && current_user && ((current_user.id == sound.user_id) || current_user.admin))}
               value = sheetSounds.count
            end
         elsif(type == "Sound")
            #Sounds to handle
            allSounds = subsheet.sounds.order("created_on desc")
            sheetSounds = allSounds.select{|sound| (sound.reviewed && ((!current_user && sound.bookgroup.name == "Peter Rabbit") || (current_user && sound.bookgroup_id <= getBookGroups(current_user)))) || (!sound.reviewed && current_user && ((current_user.id == sound.user_id) || current_user.admin))}
            value = sheetSounds
         end
         return value
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         mainsheetFound = Mainsheet.find_by_id(params[:id])
         if(mainsheetFound)
            radioFound = Radiostation.find_by_name(params[:radiostation_id])
            if(radioFound && mainsheetFound.radiostation_id == radioFound.id)
               sheetSubsheets = mainsheetFound.subsheets.order("created_on desc")
               sheets = sheetSubsheets.select{|subsheet| (((!current_user && subsheet.bookgroup.name == "Peter Rabbit") || (current_user && subsheet.bookgroup_id <= getBookGroups(current_user))) && ((subsheet.sounds.count > 0) || (subsheet.favoritesounds.count > 0))) || (current_user && subsheet.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subsheet.user_id) || current_user.admin) || subsheet.collab_mode))}

               guest = (!current_user && sheets.count > 0)
               if(current_user)
                  owner = ((mainsheetFound.user_id == current_user.id) || current_user.admin)
                  visitor = (!owner && sheets.count > 0)
                  group = ((sheets.count > 0 || sheets.count == 0) && owner)
               end

               if(current_user && (group || visitor) || guest)
                  @mainsheet = mainsheetFound
                  @subsheets = Kaminari.paginate_array(sheets).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == mainsheetFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@mainsheet.title} was successfully removed."
                        @mainsheet.destroy
                        if(logged_in.admin)
                           redirect_to mainsheets_path
                        else
                           redirect_to user_radiostations_path(radioFound.user)
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
         sheetFound = Mainsheet.find_by_id(params[:id])
         if(sheetFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == sheetFound.user_id) || logged_in.admin))
               @mainsheet = sheetFound
               @radiostation = Radiostation.find_by_id(sheetFound.radiostation_id)
               if(type == "update")
                  if(@mainsheet.update_attributes(params[:mainsheet]))
                     flash[:success] = "#{@mainsheet.title} was successfully updated."
                     redirect_to radiostation_mainsheet_path(@mainsheet.radiostation, @mainsheet)
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
                  allMainsheets = Mainsheet.order("created_on desc")
                  @mainsheets = Kaminari.paginate_array(allMainsheets).page(params[:page]).per(10)
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
                  radioFound = Radiostation.find_by_name(params[:radiostation_id])
                  if(radioFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == radioFound.user_id))
                        newSheet = radioFound.mainsheets.new
                        if(type == "create")
                           newSheet = radioFound.mainsheets.new(params[:mainsheet])
                           newSheet.created_on = currentTime
                           newSheet.user_id = logged_in.id
                        end
                        @radiostation = radioFound
                        @mainsheet = newSheet
                        if(type == "create")
                           if(@mainsheet.save)
                              flash[:success] = "#{@mainsheet.title} was successfully created."
                              redirect_to radiostation_mainsheet_path(@mainsheet.radiostation, @mainsheet)
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
