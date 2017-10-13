module MoviestarsHelper

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

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allStars = Moviestar.order("created_on desc")
                  @moviestars = Kaminari.paginate_array(allStars).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "star")
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
                        allStars = movieFound.moviestars.order("created_on desc")
                        starFound = allStars.select{|star| star.user_id == logged_in.id}
                        if(starFound.count > 0)
                           #Destroy
                           @moviestar = Moviestar.find_by_id(starFound)
                           @movie = movieFound
                           flash[:success] = "Star was successfully removed."
                           @moviestar.destroy
                           redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
                        else
                           #Create
                           newStar = movieFound.moviestars.new(params[:moviestar])
                           newStar.created_on = currentTime
                           newStar.user_id = logged_in.id
                           @moviestar = newStar
                           @movie = movieFound
                           if(@moviestar.save)
                              #Points go here
                              #Mailer goes here as well
                              flash[:success] = "A new star was successfully created."
                              redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
                           else
                              raise "I could not save the data due to an issue problem"
                           end
                        end   
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  starFound = Moviestar.find_by_id(params[:id])
                  if(starFound)
                     @moviestar = starFound
                     @movie = Movie.find_by_id(starFound.movie_id)
                     flash[:success] = "Star by #{@moviestar.user.vname} was successfully removed."
                     @moviestar.destroy
                     redirect_to moviestars_path
                  else
                     render "start/crazybat"
                  end                  
               else
                  redirect_to root_path
               end
            end
         end
      end
end
