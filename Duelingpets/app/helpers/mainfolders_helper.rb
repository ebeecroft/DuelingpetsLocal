module MainfoldersHelper

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

      def getFolderArts(subfolder, type)
         value = ""
         if(type == "Array")
            #Favorites to handle
            allFavorites = subfolder.order("created_on desc")
            folderFavorites = allFavorites.select{|favorite| favorite.art.reviewed && ((!current_user && favorite.art.bookgroup.name == "Peter Rabbit") || (current_user && favorite.art.bookgroup_id <= getBookGroups(current_user)))}
            favorite = folderFavorites.first
            value = favorite
         elsif(type == "Count")
            if(subfolder.fave_folder)
               #Favorites count
               allFavorites = subfolder.favoritearts.order("created_on desc")
               folderFavorites = allFavorites.select{|favorite| favorite.art.reviewed && ((!current_user && favorite.art.bookgroup.name == "Peter Rabbit") || (current_user && favorite.art.bookgroup_id <= getBookGroups(current_user)))}
               value = folderFavorites.count
            else
               #Arts count
               allArts = subfolder.arts.order("created_on desc")
               folderArts = allArts.select{|art| (art.reviewed && ((!current_user && art.bookgroup.name == "Peter Rabbit") || (current_user && art.bookgroup_id <= getBookGroups(current_user)))) || (!art.reviewed && current_user && ((current_user.id == art.user_id) || current_user.admin))}
               value = folderArts.count
            end
         elsif(type == "Art")
            #Arts to handle
            allArts = subfolder.arts.order("created_on desc")
            folderArts = allArts.select{|art| (art.reviewed && ((!current_user && art.bookgroup.name == "Peter Rabbit") || (current_user && art.bookgroup_id <= getBookGroups(current_user)))) || (!art.reviewed && current_user && ((current_user.id == art.user_id) || current_user.admin))}
            value = folderArts
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
         mainfolderFound = Mainfolder.find_by_id(params[:id])
         if(mainfolderFound)
            galleryFound = Gallery.find_by_name(params[:gallery_id])
            if(galleryFound && mainfolderFound.gallery_id == galleryFound.id)
               folderSubfolders = mainfolderFound.subfolders.order("created_on desc")
               folders = folderSubfolders.select{|subfolder| (((!current_user && subfolder.bookgroup.name == "Peter Rabbit") || (current_user && subfolder.bookgroup_id <= getBookGroups(current_user))) && ((subfolder.arts.count > 0) || (subfolder.favoritearts.count > 0))) || (current_user && subfolder.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subfolder.user_id) || current_user.admin) || subfolder.collab_mode))}

               guest = (!current_user && folders.count > 0)
               if(current_user)
                  owner = ((mainfolderFound.user_id == current_user.id) || current_user.admin)
                  visitor = (!owner && folders.count > 0)
                  group = ((folders.count > 0 || folders.count == 0) && owner)
               end

               if(current_user && (group || visitor) || guest)
                  @mainfolder = mainfolderFound
                  @subfolders = Kaminari.paginate_array(folders).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == mainfolderFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@mainfolder.title} was successfully removed."
                        @mainfolder.destroy
                        if(logged_in.admin)
                           redirect_to mainfolders_path
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
         folderFound = Mainfolder.find_by_id(params[:id])
         if(folderFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == folderFound.user_id) || logged_in.admin))
               @mainfolder = folderFound
               @gallery = Gallery.find_by_id(folderFound.gallery_id)
               if(type == "update")
                  if(@mainfolder.update_attributes(params[:mainfolder]))
                     flash[:success] = "#{@mainfolder.title} was successfully updated."
                     redirect_to gallery_mainfolder_path(@mainfolder.gallery, @mainfolder)
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
                  allMainfolders = Mainfolder.order("created_on desc")
                  @mainfolders = Kaminari.paginate_array(allMainfolders).page(params[:page]).per(10)
               else
                  redirect_to root_path
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
                  galleryFound = Gallery.find_by_name(params[:gallery_id])
                  if(galleryFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == galleryFound.user_id))
                        newFolder = galleryFound.mainfolders.new
                        if(type == "create")
                           newFolder = galleryFound.mainfolders.new(params[:mainfolder])
                           newFolder.created_on = currentTime
                           newFolder.user_id = logged_in.id
                        end
                        @gallery = galleryFound
                        @mainfolder = newFolder
                        if(type == "create")
                           if(@mainfolder.save)
                              flash[:success] = "#{@mainfolder.title} was successfully created."
                              redirect_to gallery_mainfolder_path(@mainfolder.gallery, @mainfolder)
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
            end
         end
      end
end
