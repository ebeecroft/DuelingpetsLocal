module FavoritesoundsHelper

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

      def destroyCommons
         soundFound = Sound.find_by_id(params[:sound_id])
         if(soundFound)
            logged_in = current_user
            if(logged_in && ((soundFound.user_id != logged_in.id) && (soundFound.bookgroup_id <= getBookGroups(logged_in))))
               allFaves = soundFound.favoritesounds.order("created_on desc")
               faveFound = allFaves.select{|fave| ((fave.user_id == logged_in.id) || logged_in.admin)}
               if(faveFound.count > 0)
                  @favoritesound = Favoritesound.find_by_id(faveFound)
                  @sound = soundFound
                  flash[:success] = "Fave was successfully removed."
                  @favoritesound.destroy
                  if(logged_in.admin)
                     redirect_to favoritesounds_path
                  else
                     redirect_to subsheet_sound_path(@sound.subsheet, @sound)
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

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allFaves = Favoritesound.order("created_on desc")
                  @favoritesounds = Kaminari.paginate_array(allFaves).page(params[:page]).per(10)
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
                  soundFound = Sound.find_by_id(params[:sound_id])
                  if(soundFound)
                     logged_in = current_user
                     if(logged_in && ((soundFound.user_id != logged_in.id) && (soundFound.bookgroup_id <= getBookGroups(logged_in))))
                        #We need to eventually check that the favorite folders is not null
                        allSubsheets = Subsheet.order("created_on desc")
                        allFavfolders = allSubsheets.select{|subsheet| subsheet.fave_folder && ((subsheet.user_id == logged_in.id) || (subsheet.collab_mode && subsheet.user_id != soundFound.user_id))}
                        if(allFavfolders.count > 0)
                           @subsheets = allFavfolders
                           newFave = soundFound.favoritesounds.new
                           if(type == "create")
                              newFave = soundFound.favoritesounds.new(params[:favoritesound])
                              newFave.created_on = currentTime
                              newFave.user_id = logged_in.id
                           end
                           @favoritesound = newFave
                           @sound = soundFound
                           if(type == "create")
                              if(@favoritesound.save)
                                 pouch = Pouch.find_by_user_id(soundFound.user_id)
                                 pointsForFave = 144
                                 pouch.amount += pointsForFave
                                 UserMailer.sound_favorited(@favoritesound, pointsForFave).deliver
                                 @pouch = pouch
                                 @pouch.save
                                 flash[:success] = "A new favorite was successfully created."
                                 redirect_to subsheet_sound_path(@sound.subsheet, @sound)
                              else
                                 render "new"
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
            elsif(type == "destroy")
               if(current_user && current_user.admin)
                  destroyCommons
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
                     destroyCommons
                  end
               end
            end
         end
      end
end
