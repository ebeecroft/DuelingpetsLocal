module SoundsHelper

   private
      def getSoundVisitors(timeframe, sound)
         #Time values
         allVisits = sound.soundvisits.order("created_on desc")
         pastTwenty = allVisits.select{|visit| (currentTime - visit.created_on) <= 20.minutes}
         pastFourty = allVisits.select{|visit| (currentTime - visit.created_on) <= 40.minutes}
         pasthour = allVisits.select{|visit| (currentTime - visit.created_on) <= 1.hour}
         past2hours = allVisits.select{|visit| (currentTime - visit.created_on) <= 2.hours}
         past3hours = allVisits.select{|visit| (currentTime - visit.created_on) <= 3.hours}

         #Count values
         past20MinsCount = pastTwenty.count
         past40MinsCount = pastFourty.count - past20MinsCount
         pasthourCount = pasthour.count - past40MinsCount - past20MinsCount
         past2hoursCount = past2hours.count - pasthourCount - past40MinsCount - past20MinsCount
         past3hoursCount =  past3hours.count - past2hoursCount - pasthourCount - past40MinsCount - past20MinsCount

         #value = past20Count
         if(timeframe == "past20mins")
            value = past20MinsCount
         elsif(timeframe == "past40mins")
            value = past40MinsCount
         elsif(timeframe == "pasthour")
            value = pasthourCount
         elsif(timeframe == "past2hours")
            value = past2hoursCount
         elsif(timeframe == "past3hours")
            value = past3hoursCount
         end
         return value
      end

      def cleanupOldVisits
         allVisits = Soundvisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @soundvisit = visit
               @soundvisit.destroy
            end
         end
      end

      def saveVisit(soundFound, visitor)
         allVisits = soundFound.soundvisits.order("created_on desc")
         soundVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.mins) && (visit.user_id == visitor.id)}
         if(soundVisited.count == 0)
            #Add visitor to list
            newVisit = soundFound.soundvisits.new(params[:soundvisit])
            newVisit.user_id = visitor.id
            newVisit.created_on = currentTime
            @soundvisit = newVisit
            @soundvisit.save
         end
      end

      def visitTimer(type, soundFound)
         #Determines if we have visitors to our page
         if(type == "show")
            visitor = current_user
            if(visitor)
               userPouch = Pouch.find_by_user_id(visitor.id)
               userPouch.last_visited = currentTime
               @pouch = userPouch
               @pouch.save

               #Checks to see that the visitor and
               #our user are not the same
               if(visitor.id != radioFound.user_id && !visitor.admin)
                  timer = Pagetimer.find_by_name("Sound")
                  if(timer.expiretime - currentTime <= 0)
                     value = duration.min.from_now.utc
                     timer.expiretime = value
                     @pagetimer = pagetimer
                     @pagetimer.save
                     saveVisit(soundFound, visitor)
                  else
                     saveVisit(soundFound, visitor)
                  end
               end
            end
         end
      end

      def retrieveSoundFave(sound, type)
         allFaves = sound.favoritesounds.order("created_on desc")
         faveFound = allFaves.select{|fave| fave.user_id == current_user.id}
         favorite = Favoritesound.find_by_id(faveFound)
         fave = favorite
         if(type == "Count")
            fave = faveFound
         end
         return fave
      end

      def retrieveSoundStar(sound)
         allStars = sound.soundstars.order("created_on desc")
         starFound = allStars.select{|star| star.user_id == current_user.id}
         return starFound.count
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         soundFound = Sound.find_by_id(params[:id])
         if(soundFound)
            guest = (!current_user && soundFound.reviewed && soundFound.bookgroup.name == "Peter Rabbit")
            if(current_user)
               visitTimer(type, soundFound)
               cleanupOldVisits
               owner = ((soundFound.user_id == current_user.id) || current_user.admin)
               visitor = (!owner && soundFound.reviewed && soundFound.bookgroup_id <= getBookGroups(current_user))
               sound = (owner && (soundFound.reviewed && soundFound.bookgroup_id <= getBookGroups(current_user)) || !soundFound.reviewed)
            end
            if((current_user && (sound || visitor)) || guest)
               @sound = soundFound
               @subsheet = Subsheet.find_by_id(soundFound.subsheet_id)
               soundcomments = @sound.soundcomments.order("created_on desc")
               @soundcomments = Kaminari.paginate_array(soundcomments).page(params[:page]).per(10)
               stars = @sound.soundstars.count
               @stars = stars
               faves = @sound.favoritesounds.count
               @faves = faves
               if(type == "destroy")
                  logged_in = current_user
                  if(logged_in && ((logged_in.id == soundFound.user_id) || logged_in.admin))
                     flash[:success] = "#{@sound.title} was successfully removed."
                     @sound.destroy
                     if(logged_in.admin)
                        redirect_to sounds_path
                     else
                        redirect_to mainsheet_subsheet_path(@subsheet.mainsheet, @subsheet)
                     end
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         soundFound = Sound.find_by_id(params[:id])
         if(soundFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == soundFound.subsheet.user_id) || soundFound.subsheet.collab_mode) || logged_in.admin)
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @sound = soundFound
               @subsheet = Subsheet.find_by_id(soundFound.subsheet_id)
               if(type == "update")
                  if(@sound.update_attributes(params[:sound]))
                     flash[:success] = "Sound #{@sound.title} was successfully updated."
                     redirect_to subsheet_sound_path(@sound.subsheet, @sound)
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
                  allSounds = Sound.order("created_on desc")
                  @sounds = Kaminari.paginate_array(allSounds).page(params[:page]).per(9)
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
                  sheetFound = Subsheet.find_by_id(params[:subsheet_id])
                  if(sheetFound)
                     logged_in = current_user
                     if(logged_in && sheetFound.user_id == logged_in.id || (sheetFound.collab_mode && (sheetFound.bookgroup_id <= getBookGroups(logged_in))))
                        if(!sheetFound.fave_folder)
                           allGroups = Bookgroup.order("created_on desc")
                           allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                           @group = allowedGroups
                           newSound = sheetFound.sounds.new
                           if(type == "create")
                              newSound = sheetFound.sounds.new(params[:sound])
                              newSound.created_on = currentTime
                              newSound.user_id = logged_in.id
                           end
                           @sound = newSound
                           @subsheet = sheetFound
                           if(type == "create")
                              if(@sound.save)
                                 ContentMailer.sound_review(@sound).deliver
                                 flash[:success] = "Sound #{@sound.title} was successfully created."
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
            elsif(type == "review")
               logged_in = current_user
               if(logged_in)
                  allSounds = Sound.order("created_on desc")
                  pouchFound = Pouch.find_by_user_id(logged_in.id)
                  if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                     soundsToReview = allSounds.select{|sound| !sound.reviewed}
                     @sounds = Kaminari.paginate_array(soundsToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "approve" || type == "deny")
               logged_in = current_user
               if(logged_in)
                  soundFound = Sound.find_by_id(params[:sound_id])
                  if(soundFound)
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                        if(type == "approve")
                           soundFound.reviewed = true
                           pouch = Pouch.find_by_user_id(soundFound.user_id)
                           pointsForSound = 200
                           pouch.amount += pointsForSound
                           @pouch = pouch
                           @pouch.save
                           @sound = soundFound
                           @sound.save
                           ContentMailer.sound_approved(@sound, pointsForSound).deliver
                           allWatches = Watch.all
                           watchers = allWatches.select{|watch| (((watch.watchtype.name == "Sounds" || watch.watchtype.name == "Blogsounds") || (watch.watchtype.name == "Artsounds" || watch.watchtype.name == "Moviesounds")) || (watch.watchtype.name == "Maincontent" || watch.watchtype.name == "All")) && watch.from_user.id != @sound.user_id}
                           if(watchers.count > 0)
                              watchers.each do |watch|
                                 UserMailer.new_sound(@sound, watch).deliver
                              end
                           end
                           value = "#{@sound.user.vname}'s sound #{@sound.title} was approved."
                        else
                           @sound = soundFound
                           ContentMailer.sound_denied(@sound).deliver
                           value = "#{@sound.user.vname}'s sound #{@sound.title} was denied."
                        end
                        flash[:success] = value
                        redirect_to sounds_review_path
                     else
                        redirect_to root_path
                     end
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
