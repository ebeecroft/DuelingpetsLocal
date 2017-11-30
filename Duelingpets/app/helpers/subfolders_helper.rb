module SubfoldersHelper

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
         subfolderFound = Subfolder.find_by_id(params[:id])
         if(subfolderFound)
            mainfolderFound = Mainfolder.find_by_id(params[:mainfolder_id])
            if(mainfolderFound && subfolderFound.mainfolder_id == mainfolderFound.id)
               type = ""
               if(subfolderFound.fave_folder)
                  #Favorites to handle
                  allFavorites = subfolderFound.favoritearts.order("created_on desc")
                  folderFavorites = allFavorites.select{|favorite| favorite.art.reviewed && ((!current_user && favorite.art.bookgroup.name == "Peter Rabbit") || (current_user && favorite.art.bookgroup_id <= getBookGroups(current_user)))}
                  type = folderFavorites
               else
                  #Arts to handle
                  allArts = subfolderFound.arts.order("created_on desc")
                  folderArts = allArts.select{|art| (art.reviewed && ((!current_user && art.bookgroup.name == "Peter Rabbit") || (current_user && art.bookgroup_id <= getBookGroups(current_user)))) || (!art.reviewed && current_user && ((current_user.id == art.user_id) || current_user.admin))}
                  type = folderArts
               end

               #Defines the owners and guests for favorites and arts
               guest = (!current_user && type.count > 0 && subfolderFound.bookgroup.name == "Peter Rabbit")
               if(current_user)
                  owner = ((subfolderFound.user_id == current_user.id) || current_user.admin)
                  visitor = (((subfolderFound.bookgroup_id <= getBookGroups(current_user)) && (type.count > 0 || subfolderFound.collab_mode)) && !owner)
                  group = (((subfolderFound.bookgroup_id <= getBookGroups(current_user)) && (type.count == 0 || type.count > 0)) && owner)
               end

               #Checks which user is using the show view
               if((current_user && (group || visitor)) || guest)
                  @subfolder = subfolderFound
                  @mainfolder = mainfolderFound

                  #Sets up the variables dependent on the folder type
                  if(subfolderFound.fave_folder)
                     @favoritearts = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  else
                     @arts = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  end

                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == subfolderFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@subfolder.title} was successfully removed."
                        @subfolder.destroy
                        if(logged_in.admin)
                           redirect_to subfolders_path
                        else
                           redirect_to gallery_mainfolder_path(mainfolderFound.gallery, mainfolderFound)
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
         subfolderFound = Subfolder.find_by_id(params[:id])
         if(subfolderFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == subfolderFound.user_id) || logged_in.admin))
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @subfolder = subfolderFound
               @mainfolder = Mainfolder.find_by_id(@subfolder.mainfolder_id)
               if(type == "update")
                  if(@subfolder.update_attributes(params[:subfolder]))
                     flash[:success] = "#{@subfolder.title} was successfully updated."
                     redirect_to mainfolder_subfolder_path(@subfolder.mainfolder, @subfolder)
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
                  allSubfolders = Subfolder.order("created_on desc")
                  @subfolders = Kaminari.paginate_array(allSubfolders).page(params[:page]).per(10)
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
                  mainfolderFound = Mainfolder.find_by_id(params[:mainfolder_id])
                  if(mainfolderFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == mainfolderFound.user_id))
                        allGroups = Bookgroup.order("created_on desc")
                        allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                        @group = allowedGroups
                        newSubfolder = mainfolderFound.subfolders.new
                        if(type == "create")
                           newSubfolder = mainfolderFound.subfolders.new(params[:subfolder])
                           newSubfolder.created_on = currentTime
                           newSubfolder.user_id = logged_in.id
                        end
                        @mainfolder = mainfolderFound
                        @subfolder = newSubfolder
                        if(type == "create")
                           if(@subfolder.save)
                              flash[:success] = "#{@subfolder.title} was successfully created."
                              redirect_to mainfolder_subfolder_path(@subfolder.mainfolder, @subfolder)
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


