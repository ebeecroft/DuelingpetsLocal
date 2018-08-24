module GalleriesHelper

   private
      def getGalleryVisitors(timeframe, gallery)
         #Time values
         allVisits = gallery.channelvisits.order("created_on desc")
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
         allVisits = Galleryvisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @galleryvisit = visit
               @galleryvisit.destroy
            end
         end
      end

      def saveVisit(galleryFound, visitor)
         allVisits = galleryFound.galleryvisits.order("created_on desc")
         galleryVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.mins) && (visit.user_id == visitor.id)}
         if(galleryVisited.count == 0)
            #Add visitor to list
            newVisit = galleryFound.galleryvisits.new(params[:galleryvisit])
            newVisit.user_id = visitor.id
            newVisit.created_on = currentTime
            @galleryvisit = newVisit
            @galleryvisit.save
         end
      end

      def visitTimer(type, galleryFound)
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
               if(visitor.id != channelFound.user_id && !visitor.admin)
                  timer = Pagetimer.find_by_name("Gallery")
                  if(timer.expiretime - currentTime <= 0)
                     value = duration.min.from_now.utc
                     timer.expiretime = value
                     @pagetimer = pagetimer
                     @pagetimer.save
                     saveVisit(galleryFound, visitor)
                  else
                     saveVisit(galleryFound, visitor)
                  end
               end
            end
         end
      end

      def getSubfolders(mainfolder)
         mainfolderSubfolders = mainfolder.subfolders.order("created_on desc")
         subfolders = mainfolderSubfolders.select{|subfolder| (((!current_user && subfolder.bookgroup.name == "Peter Rabbit") || (current_user && subfolder.bookgroup_id <= getBookGroups(current_user))) && ((subfolder.arts.count > 0) || (subfolder.favoritearts.count > 0))) || (current_user && subfolder.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subfolder.user_id) || current_user.admin) || subfolder.collab_mode))}
         mainfolder.subfolders.each do |subfolder|
            getCollabs
            if(subfolder.collab_mode)
               collabCounter(1)
            end
         end

         return subfolders
      end

      def musicCommons(type)
         galleryFound = Gallery.find_by_id(params[:id])
         if(galleryFound)
            if(type == "gmusiccontrol")
               music_value = ""
               if(checkMusicFlag == "On")
                  music_value = "Off"
               else
                  music_value = "On"
               end
               cookies[:music_on] = {:value => music_value}
               @gallery = galleryFound
               redirect_to user_gallery_path(@gallery.user, @gallery)
            else
               if(current_user && current_user.id == galleryFound.user_id)
                  if(galleryFound.music_on)
                     galleryFound.music_on = false
                  else
                     galleryFound.music_on = true
                  end
                  @gallery = galleryFound
                  @gallery.save
                  redirect_to user_gallery_path(@gallery.user, @gallery)
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
         galleryFound = Gallery.find_by_name(params[:id])
         if(galleryFound)
            userFound = User.find_by_vname(params[:user_id])
            if(userFound && galleryFound.user_id == userFound.id)
               galleryMainfolders = galleryFound.mainfolders.order("created_on desc")
               folders = galleryMainfolders.select{|mainfolder| mainfolder.subfolders.count > 0 || (current_user && (current_user.id == mainfolder.user_id) || current_user.admin)}
               if(folders.count > 0 || current_user && ((current_user.id == galleryFound.user_id) || current_user.admin))
                  @gallery = galleryFound
                  @mainfolders = Kaminari.paginate_array(folders).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == galleryFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@gallery.name} was successfully removed."
                        @gallery.destroy
                        if(logged_in.admin)
                           redirect_to galleries_list_path
                        else
                           redirect_to user_galleries_path(galleryFound.user)
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
         galleryFound = Gallery.find_by_name(params[:id])
         if(galleryFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == galleryFound.user_id) || logged_in.admin))
               @gallery = galleryFound
               @user = User.find_by_vname(galleryFound.user.vname)
               if(type == "update")
                  if(@gallery.update_attributes(params[:gallery]))
                     flash[:success] = "#{@gallery.name} was successfully updated."
                     redirect_to user_gallery_path(@user, @gallery)
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
               allGalleries = userFound.galleries.order("created_on desc")
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allGalleries = Gallery.order("created_on desc")
         end
         @galleries = Kaminari.paginate_array(allGalleries).page(params[:page]).per(10)
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
                  galleryMode = Maintenancemode.find_by_id(8)
                  if(allMode.maintenance_on || galleryMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
                     end
                  else
                     indexCommons
                  end
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               galleryMode = Maintenancemode.find_by_id(8)
               if(allMode.maintenance_on || galleryMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/galleries/maintenance"
                  end
               else
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newGallery = logged_in.galleries.new
                        if(type == "create")
                           newGallery = logged_in.galleries.new(params[:gallery])
                           newGallery.created_on = currentTime
                        end
                        @user = userFound
                        @gallery = newGallery
                        if(type == "create")
                           if(@gallery.save)
                              flash[:success] = "#{@gallery.name} was successfully created."
                              redirect_to user_gallery_path(@user, @gallery)
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
                  galleryMode = Maintenancemode.find_by_id(8)
                  if(allMode.maintenance_on || galleryMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
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
                  galleryMode = Maintenancemode.find_by_id(8)
                  if(allMode.maintenance_on || galleryMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
                     end
                  else
                     showCommons(type)
                  end
               end
            elsif(type == "musiccontrol" || "gmusiccontrol")
               allMode = Maintenancemode.find_by_id(1)
               galleryMode = Maintenancemode.find_by_id(8)
               if(allMode.maintenance_on || galleryMode.maintenance_on)
                  if(current_user && current_user.admin)
                     musicCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
                     end
                  end
               else
                  musicCommons(type)
               end
            elsif(type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allGalleries = Gallery.order("created_on desc")
                  @galleries = Kaminari.paginate_array(allGalleries).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
