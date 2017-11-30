module FavoritemoviesHelper

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
         movieFound = Movie.find_by_id(params[:movie_id])
         if(movieFound)
            logged_in = current_user
            if(logged_in && ((movieFound.user_id != logged_in.id) && (movieFound.bookgroup_id <= getBookGroups(logged_in))))
               allFaves = movieFound.favoritemovies.order("created_on desc")
               faveFound = allFaves.select{|fave| ((fave.user_id == logged_in.id) || logged_in.admin)}
               if(faveFound.count > 0)
                  @favoritemovie = Favoritemovie.find_by_id(faveFound)
                  @movie = movieFound
                  flash[:success] = "Fave was successfully removed."
                  @favoritemovie.destroy
                  if(logged_in.admin)
                     redirect_to favoritemovies_path
                  else
                     redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
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
                  allFaves = Favoritemovie.order("created_on desc")
                  @favoritemovies = Kaminari.paginate_array(allFaves).page(params[:page]).per(10)
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
                  movieFound = Movie.find_by_id(params[:movie_id])
                  if(movieFound)
                     logged_in = current_user
                     if(logged_in && ((movieFound.user_id != logged_in.id) && (movieFound.bookgroup_id <= getBookGroups(logged_in))))
                        #We need to eventually check that the favorite folders is not null
                        allSubplaylists = Subplaylist.order("created_on desc")
                        allFavfolders = allSubplaylists.select{|subplaylist| subplaylist.fave_folder && ((subplaylist.user_id == logged_in.id) || (subplaylist.collab_mode && subplaylist.user_id != movieFound.user_id))}
                        if(allFavfolders.count > 0)
                           @subplaylists = allFavfolders
                           newFave = movieFound.favoritemovies.new
                           if(type == "create")
                              newFave = movieFound.favoritemovies.new(params[:favoritemovie])
                              newFave.created_on = currentTime
                              newFave.user_id = logged_in.id
                           end
                           @favoritemovie = newFave
                           @movie = movieFound
                           if(type == "create")
                              if(@favoritemovie.save)
                                 pouch = Pouch.find_by_user_id(movieFound.user_id)
                                 pointsForFave = 144
                                 pouch.amount += pointsForFave
                                 UserMailer.movie_favorited(@favoritemovie, pointsForFave).deliver
                                 @pouch = pouch
                                 @pouch.save
                                 flash[:success] = "A new favorite was successfully created."
                                 redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
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
                  channelMode = Maintenancemode.find_by_id(7)
                  if(allMode.maintenance_on || channelMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/channels/maintenance"
                     end
                  else
                     destroyCommons
                  end
               end
            end
         end
      end
end
