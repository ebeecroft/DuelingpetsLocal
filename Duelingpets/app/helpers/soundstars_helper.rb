module SoundstarsHelper

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

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allStars = Soundstar.order("created_on desc")
                  @soundstars = Kaminari.paginate_array(allStars).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "star")
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
                        allStars = soundFound.soundstars.order("created_on desc")
                        starFound = allStars.select{|star| star.user_id == logged_in.id}
                        if(starFound.count > 0)
                           #Destroy
                           @soundstar = Soundstar.find_by_id(starFound)
                           @sound = soundFound
                           flash[:success] = "Star was successfully removed."
                           @soundstar.destroy
                           redirect_to subsheet_sound_path(@sound.subsheet, @sound)
                        else
                           #Create
                           newStar = soundFound.soundstars.new(params[:soundstar])
                           newStar.created_on = currentTime
                           newStar.user_id = logged_in.id
                           @soundstar = newStar
                           @sound = soundFound
                           if(@soundstar.save)
                              pouch = Pouch.find_by_user_id(soundFound.user_id)
                              pointsForStar = 48
                              pouch.amount += pointsForStar
                              UserMailer.sound_starred(@soundstar, pointsForStar).deliver
                              @pouch = pouch
                              @pouch.save
                              flash[:success] = "A new star was successfully created."
                              redirect_to subsheet_sound_path(@sound.subsheet, @sound)
                           else
                              raise "I could not save the data due to an issue problem"
                           end
                        end   
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  starFound = Soundstar.find_by_id(params[:id])
                  if(starFound)
                     @soundstar = starFound
                     @sound = Sound.find_by_id(starFound.sound_id)
                     flash[:success] = "Star by #{@soundstar.user.vname} was successfully removed."
                     @soundstar.destroy
                     redirect_to soundstars_path
                  else
                     render "start/crazybat"
                  end                  
               else
                  redirect_to root_path
               end
            end
         end
      end
end
