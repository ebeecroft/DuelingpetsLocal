module GalleriesHelper

   private
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
