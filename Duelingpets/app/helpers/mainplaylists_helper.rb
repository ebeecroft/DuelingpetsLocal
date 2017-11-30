module MainplaylistsHelper

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

      def getPlaylistMovies(subplaylist, type)
         value = ""
         if(type == "Array")
            #Favorites to handle
            allFavorites = subplaylist.order("created_on desc")
            playlistFavorites = allFavorites.select{|favorite| favorite.movie.reviewed && ((!current_user && favorite.movie.bookgroup.name == "Peter Rabbit") || (current_user && favorite.movie.bookgroup_id <= getBookGroups(current_user)))}
            favorite = playlistFavorites.first
            value = favorite
         elsif(type == "Count")
            if(subplaylist.fave_folder)
               #Favorites count
               allFavorites = subplaylist.favoritemovies.order("created_on desc")
               playlistFavorites = allFavorites.select{|favorite| favorite.movie.reviewed && ((!current_user && favorite.movie.bookgroup.name == "Peter Rabbit") || (current_user && favorite.movie.bookgroup_id <= getBookGroups(current_user)))}
               value = playlistFavorites.count
            else
               #Movies count
               allMovies = subplaylist.movies.order("created_on desc")
               playlistMovies = allMovies.select{|movie| (movie.reviewed && ((!current_user && movie.bookgroup.name == "Peter Rabbit") || (current_user && movie.bookgroup_id <= getBookGroups(current_user)))) || (!movie.reviewed && current_user && ((current_user.id == movie.user_id) || current_user.admin))}
               value = playlistMovies.count
            end
         elsif(type == "Movie")
            #Movies to handle
            allMovies = subplaylist.movies.order("created_on desc")
            playlistMovies = allMovies.select{|movie| (movie.reviewed && ((!current_user && movie.bookgroup.name == "Peter Rabbit") || (current_user && movie.bookgroup_id <= getBookGroups(current_user)))) || (!movie.reviewed && current_user && ((current_user.id == movie.user_id) || current_user.admin))}
            value = playlistMovies
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
         mainplaylistFound = Mainplaylist.find_by_id(params[:id])
         if(mainplaylistFound)
            channelFound = Channel.find_by_name(params[:channel_id])
            if(channelFound && mainplaylistFound.channel_id == channelFound.id)
               playlistSublists = mainplaylistFound.subplaylists.order("created_on desc")
               playlists = playlistSublists.select{|subplaylist| (((!current_user && subplaylist.bookgroup.name == "Peter Rabbit") || (current_user && subplaylist.bookgroup_id <= getBookGroups(current_user))) && ((subplaylist.movies.count > 0) || (subplaylist.favoritemovies.count > 0))) || (current_user && subplaylist.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subplaylist.user_id) || current_user.admin) || subplaylist.collab_mode))}

               guest = (!current_user && playlists.count > 0)
               if(current_user)
                  owner = ((mainplaylistFound.user_id == current_user.id) || current_user.admin)
                  visitor = (!owner && playlists.count > 0)
                  group = ((playlists.count > 0 || playlists.count == 0) && owner)
               end

               if(current_user && (group || visitor) || guest)
                  @mainplaylist = mainplaylistFound
                  @subplaylists = Kaminari.paginate_array(playlists).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == mainplaylistFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@mainplaylist.title} was successfully removed."
                        @mainplaylist.destroy
                        if(logged_in.admin)
                           redirect_to mainplaylists_path
                        else
                           redirect_to user_channels_path(channelFound.user)
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
         playlistFound = Mainplaylist.find_by_id(params[:id])
         if(playlistFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == playlistFound.user_id) || logged_in.admin))
               @mainplaylist = playlistFound
               @channel = Channel.find_by_id(playlistFound.channel_id)
               if(type == "update")
                  if(@mainplaylist.update_attributes(params[:mainplaylist]))
                     flash[:success] = "#{@mainplaylist.title} was successfully updated."
                     redirect_to channel_mainplaylist_path(@mainplaylist.channel, @mainplaylist)
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
                  allMainplaylists = Mainplaylist.order("created_on desc")
                  @mainplaylists = Kaminari.paginate_array(allMainplaylists).page(params[:page]).per(10)
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
                  channelFound = Channel.find_by_name(params[:channel_id])
                  if(channelFound)
                     logged_in = current_user
                     if(logged_in && (logged_in.id == channelFound.user_id))
                        newPlaylist = channelFound.mainplaylists.new
                        if(type == "create")
                           newPlaylist = channelFound.mainplaylists.new(params[:mainplaylist])
                           newPlaylist.created_on = currentTime
                           newPlaylist.user_id = logged_in.id
                        end
                        @channel = channelFound
                        @mainplaylist = newPlaylist
                        if(type == "create")
                           if(@mainplaylist.save)
                              flash[:success] = "#{@mainplaylist.title} was successfully created."
                              redirect_to channel_mainplaylist_path(@mainplaylist.channel, @mainplaylist)
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
