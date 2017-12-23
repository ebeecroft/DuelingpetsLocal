module FavoriteartsHelper

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
         artFound = Art.find_by_id(params[:art_id])
         if(artFound)
            logged_in = current_user
            if(logged_in && ((artFound.user_id != logged_in.id) && (artFound.bookgroup_id <= getBookGroups(logged_in))))
               allFaves = artFound.favoritearts.order("created_on desc")
               faveFound = allFaves.select{|fave| ((fave.user_id == logged_in.id) || logged_in.admin)}
               if(faveFound.count > 0)
                  @favoriteart = Favoriteart.find_by_id(faveFound)
                  @art = artFound
                  flash[:success] = "Fave was successfully removed."
                  @favoriteart.destroy
                  if(logged_in.admin)
                     redirect_to favoritearts_path
                  else
                     redirect_to subfolder_art_path(@art.subfolder, @art)
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
                  allFaves = Favoriteart.order("created_on desc")
                  @favoritearts = Kaminari.paginate_array(allFaves).page(params[:page]).per(10)
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
                  artFound = Art.find_by_id(params[:art_id])
                  if(artFound)
                     logged_in = current_user
                     if(logged_in && ((artFound.user_id != logged_in.id) && (artFound.bookgroup_id <= getBookGroups(logged_in))))
                        #We need to eventually check that the favorite folders is not null
                        allSubfolders = Subfolder.order("created_on desc")
                        allFavfolders = allSubfolders.select{|subfolder| subfolder.fave_folder && ((subfolder.user_id == logged_in.id) || (subfolder.collab_mode && subfolder.user_id != artFound.user_id))}
                        if(allFavfolders.count > 0)
                           @subfolders = allFavfolders
                           newFave = artFound.favoritearts.new
                           if(type == "create")
                              newFave = artFound.favoritearts.new(params[:favoriteart])
                              newFave.created_on = currentTime
                              newFave.user_id = logged_in.id
                           end
                           @favoriteart = newFave
                           @art = artFound
                           if(type == "create")
                              if(@favoriteart.save)
                                 pouch = Pouch.find_by_user_id(artFound.user_id)
                                 pointsForFave = 144
                                 pouch.amount += pointsForFave
                                 UserMailer.art_favorited(@favoriteart, pointsForFave).deliver
                                 @pouch = pouch
                                 @pouch.save
                                 flash[:success] = "A new favorite was successfully created."
                                 redirect_to subfolder_art_path(@art.subfolder, @art)
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
                  galleryMode = Maintenancemode.find_by_id(8)
                  if(allMode.maintenance_on || galleryMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
                     end
                  else
                     destroyCommons
                  end
               end
            end
         end
      end
end
