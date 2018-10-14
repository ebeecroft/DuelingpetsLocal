module RadiostationsHelper

   private
      def getRadiostationVisitors(timeframe, radiostation)
         #Time values
         allVisits = radiostation.radiostationvisits.order("created_on desc")
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
         allVisits = Radiostationvisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @radiostationvisit = visit
               @radiostationvisit.destroy
            end
         end
      end

      def saveVisit(radioFound, visitor)
         allVisits = radioFound.radiostationvisits.order("created_on desc")
         radioVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.mins) && (visit.user_id == visitor.id)}
         if(radioVisited.count == 0)
            #Add visitor to list
            newVisit = radioFound.radiostationvisits.new(params[:radiostationvisit])
            newVisit.user_id = visitor.id
            newVisit.created_on = currentTime
            @radiostationvisit = newVisit
            @radiostationvisit.save
         end
      end

      def visitTimer(type, radioFound)
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
                  timer = Pagetimer.find_by_name("Radiostation")
                  if(timer.expiretime - currentTime <= 0)
                     value = duration.min.from_now.utc
                     timer.expiretime = value
                     @pagetimer = pagetimer
                     @pagetimer.save
                     saveVisit(radioFound, visitor)
                  else
                     saveVisit(radioFound, visitor)
                  end
               end
            end
         end
      end

      def getSubsheets(mainsheet)
         mainsheetSubsheets = mainsheet.subsheets.order("created_on desc")
         subsheets = mainsheetSubsheets.select{|subsheet| (((!current_user && subsheet.bookgroup.name == "Peter Rabbit") || (current_user && subsheet.bookgroup_id <= getBookGroups(current_user))) && ((subsheet.sounds.count > 0) || (subsheet.favoritesounds.count > 0))) || (current_user && subsheet.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subsheet.user_id) || current_user.admin) || subsheet.collab_mode))}
         mainsheet.subsheets.each do |subsheet|
            getCollabs
            if(subsheet.collab_mode)
               collabCounter(1)
            end
         end

         return subsheets
      end

      def videoCommons(type)
         radioFound = Radiostation.find_by_id(params[:id])
         if(radioFound)
            if(type == "gvideocontrol")
               video_value = ""
               if(checkVideoFlag == "On")
                  video_value = "Off"
               else
                  vido_value = "On"
               end
               cookies[:music_on] = {:value => video_value}
               @radiostation = radioFound
               redirect_to user_radiostation_path(@radiostation.user, @radiostation)
            else
               if(current_user && current_user.id == radioFound.user_id)
                  if(radioFound.video_on)
                     radioFound.video_on = false
                  else
                     radioFound.video_on = true
                  end
                  @radiostation = radioFound
                  @radiostation.save
                  redirect_to user_radiostation_path(@radiostation.user, @radiostation)
               end
            end
         else
            render "start/crazybat"
         end
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         radioFound = Radiostation.find_by_name(params[:id])
         if(radioFound)
            userFound = User.find_by_vname(params[:user_id])
            if(userFound && radioFound.user_id == userFound.id)
               radioMainsheets = radioFound.mainsheets.order("created_on desc")
               sheets = radioMainsheets.select{|mainsheet| mainsheet.subsheets.count > 0 || (current_user && (current_user.id == mainsheet.user_id) || current_user.admin)}
               if(sheets.count > 0 || current_user && ((current_user.id == radioFound.user_id) || current_user.admin))
                  visitTimer(type, radioFound)
                  cleanupOldVisits
                  @radiostation = radioFound
                  @mainsheets = Kaminari.paginate_array(sheets).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == radioFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@radiostation.name} was successfully removed."
                        @radiostation.destroy
                        if(logged_in.admin)
                           redirect_to radiostations_list_path
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
         radioFound = Radiostation.find_by_name(params[:id])
         if(radioFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == radioFound.user_id) || logged_in.admin))
               @radiostation = radioFound
               @user = User.find_by_vname(radioFound.user.vname)
               if(type == "update")
                  if(@radiostation.update_attributes(params[:radiostation]))
                     flash[:success] = "#{@radiostation.name} was successfully updated."
                     redirect_to user_radiostation_path(@user, @radiostation)
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

      def optional
         value = params[:user_id]
         return value
      end

      def indexCommons
         if(optional)
            userFound = User.find_by_vname(optional)
            if(userFound)
               allRadios = userFound.radiostations.order("created_on desc")
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allRadios = Radiostation.order("created_on desc")
         end
         @radiostations = Kaminari.paginate_array(allRadios).page(params[:page]).per(10)
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               if(current_user && current_user.admin)
                  indexCommons
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
                     indexCommons
                  end
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
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newRadio = logged_in.radiostations.new
                        if(type == "create")
                           newRadio = logged_in.radiostations.new(params[:radiostation])
                           newRadio.created_on = currentTime
                        end
                        @user = userFound
                        @radiostation = newRadio
                        if(type == "create")
                           if(@radiostation.save)
                              flash[:success] = "#{@radiostation.name} was successfully created."
                              redirect_to user_radiostation_path(@user, @radiostation)
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
            elsif(type == "videocontrol" || "gvideocontrol")
               allMode = Maintenancemode.find_by_id(1)
               radioMode = Maintenancemode.find_by_id(9)
               if(allMode.maintenance_on || radioMode.maintenance_on)
                  if(current_user && current_user.admin)
                     videoCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/radiostations/maintenance"
                     end
                  end
               else
                  videoCommons(type)
               end
            elsif(type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allRadios = Radiostation.order("created_on desc")
                  @radiostations = Kaminari.paginate_array(allRadios).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
