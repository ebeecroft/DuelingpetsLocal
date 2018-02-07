module SubplaylistsHelper

   private
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
               type = ""
               if(subplaylistFound.fave_folder)
                  #Favorites to handle
                  allFavorites = subplaylistFound.favoritemovies.order("created_on desc")
                  playlistFavorites = allFavorites.select{|favorite| favorite.movie.reviewed && ((!current_user && favorite.movie.bookgroup.name == "Peter Rabbit") || (current_user && favorite.movie.bookgroup_id <= getBookGroups(current_user)))}
                  type = playlistFavorites
               else
                  #Movies to handle
                  allMovies = subplaylistFound.movies.order("created_on desc")
                  playlistMovies = allMovies.select{|movie| (movie.reviewed && ((!current_user && movie.bookgroup.name == "Peter Rabbit") || (current_user && movie.bookgroup_id <= getBookGroups(current_user)))) || (!movie.reviewed && current_user && ((current_user.id == movie.user_id) || current_user.admin))}
                  type = playlistMovies
               end

               #Defines the owners and guests for favorites and movies
               guest = (!current_user && type.count > 0 && subplaylistFound.bookgroup.name == "Peter Rabbit")
               if(current_user)
                  owner = ((subplaylistFound.user_id == current_user.id) || current_user.admin)
                  visitor = (((subplaylistFound.bookgroup_id <= getBookGroups(current_user)) && (type.count > 0 || subplaylistFound.collab_mode)) && !owner)
                  group = (((subplaylistFound.bookgroup_id <= getBookGroups(current_user)) && (type.count == 0 || type.count > 0)) && owner)
               end

               #Checks which user is using the show view
               if((current_user && (group || visitor)) || guest)
                  @subplaylist = subplaylistFound
                  @mainplaylist = mainplaylistFound

                  #Sets up the variables dependent on the folder type
                  if(subplaylistFound.fave_folder)
                     @favoritemovies = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  else
                     @movies = Kaminari.paginate_array(type).page(params[:page]).per(9)
                  end

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
