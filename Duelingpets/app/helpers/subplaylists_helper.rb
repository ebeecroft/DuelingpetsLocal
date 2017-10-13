module SubplaylistsHelper

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
         subplaylistFound = Subplaylist.find_by_id(params[:id])
         if(subplaylistFound)
            mainplaylistFound = Mainplaylist.find_by_id(params[:mainplaylist_id])
            if(mainplaylistFound && subplaylistFound.mainplaylist_id == mainplaylistFound.id)
               subMovies = subplaylistFound.movies.order("created_on desc")
               playlistMovies = subMovies.select{|movie| (movie.reviewed && ((current_user && movie.bookgroup_id <= getBookGroups(current_user)) || (!current_user && movie.bookgroup.name == "Peter Rabbit"))) || (!movie.reviewed && current_user && ((current_user.id == movie.user_id) || current_user.admin))}

               #Defines the owners and guests
               guest = (!current_user && playlistMovies.count > 0 && subplaylistFound.bookgroup.name == "Peter Rabbit")
               if(current_user)
                  owner = ((subplaylistFound.user_id == current_user.id) || current_user.admin)
                  visitor = (((subplaylistFound.bookgroup_id <= getBookGroups(current_user)) && (playlistMovies.count > 0 || subplaylistFound.collab_mode)) && !owner)
                  group = (((subplaylistFound.bookgroup_id <= getBookGroups(current_user)) && (playlistMovies.count == 0 || playlistMovies.count > 0)) && owner)
               end

               #Checks which user is using the show view
               if((current_user && (group || visitor)) || guest)
                  @subplaylist = subplaylistFound
                  @mainplaylist = mainplaylistFound
                  @movies = Kaminari.paginate_array(playlistMovies).page(params[:page]).per(10)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == subplaylistFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@subplaylist.title} was successfully removed."
                        @subplaylist.destroy
                        if(logged_in.admin)
                           redirect_to subplaylists_path
                        else
                           redirect_to channel_mainplaylist_path(mainplaylistFound.channel, mainplaylistFound)
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
         subplaylistFound = Subplaylist.find_by_id(params[:id])
         if(subplaylistFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == subplaylistFound.user_id) || logged_in.admin))
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @subplaylist = subplaylistFound
               @mainplaylist = Mainplaylist.find_by_id(@subplaylist.mainplaylist_id)
               if(type == "update")
                  if(@subplaylist.update_attributes(params[:subplaylist]))
                     flash[:success] = "#{@subplaylist.title} was successfully updated."
                     redirect_to mainplaylist_subplaylist_path(@subplaylist.mainplaylist, @subplaylist)
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
                  allSubplaylists = Subplaylist.order("created_on desc")
                  @subplaylists = Kaminari.paginate_array(allSubplaylists).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               channelMode = Maintenancemode.find_by_id(7)
               if(allMode.maintenance_on || channelMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/channels/maintenance"
                  end
               else
                  mainplaylistFound = Mainplaylist.find_by_id(params[:mainplaylist_id])
                  if(mainplaylistFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == mainplaylistFound.user_id))
                        allGroups = Bookgroup.order("created_on desc")
                        allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                        @group = allowedGroups
                        newSubplaylist = mainplaylistFound.subplaylists.new
                        if(type == "create")
                           newSubplaylist = mainplaylistFound.subplaylists.new(params[:subplaylist])
                           newSubplaylist.created_on = currentTime
                           newSubplaylist.user_id = logged_in.id
                        end
                        @mainplaylist = mainplaylistFound
                        @subplaylist = newSubplaylist
                        if(type == "create")
                           if(@subplaylist.save)
                              flash[:success] = "#{@subplaylist.title} was successfully created."
                              redirect_to mainplaylist_subplaylist_path(@subplaylist.mainplaylist, @subplaylist)
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
                  channelMode = Maintenancemode.find_by_id(7)
                  if(allMode.maintenance_on || channelMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/channels/maintenance"
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
                  channelMode = Maintenancemode.find_by_id(7)
                  if(allMode.maintenance_on || channelMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/channels/maintenance"
                     end
                  else
                     showCommons(type)
                  end
               end
            end
         end
      end
end
