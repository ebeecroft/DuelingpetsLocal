module MoviesHelper

   private
      def getMovieVisitors(timeframe, movie)
         #Time values
         allVisits = movie.movievisits.order("created_on desc")
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
         allVisits = Movievisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @movievisit = visit
               @movievisit.destroy
            end
         end
      end

      def saveVisit(movieFound, visitor)
         allVisits = movieFound.movievisits.order("created_on desc")
         movieVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.mins) && (visit.user_id == visitor.id)}
         if(movieVisited.count == 0)
            #Add visitor to list
            newVisit = movieFound.movievisits.new(params[:movievisit])
            newVisit.user_id = visitor.id
            newVisit.created_on = currentTime
            @movievisit = newVisit
            @movievisit.save
         end
      end

      def visitTimer(type, movieFound)
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
               if(visitor.id != movieFound.user_id && !visitor.admin)
                  timer = Pagetimer.find_by_name("Movie")
                  if(timer.expiretime - currentTime <= 0)
                     value = duration.min.from_now.utc
                     timer.expiretime = value
                     @pagetimer = pagetimer
                     @pagetimer.save
                     saveVisit(movieFound, visitor)
                  else
                     saveVisit(movieFound, visitor)
                  end
               end
            end
         end
      end

      def retrieveFave(movie, type)
         allFaves = movie.favoritemovies.order("created_on desc")
         faveFound = allFaves.select{|fave| fave.user_id == current_user.id}
         favorite = Favoritemovie.find_by_id(faveFound)
         fave = favorite
         if(type == "Count")
            fave = faveFound
         end
         return fave
      end

      def retrieveStar(movie)
         allStars = movie.moviestars.order("created_on desc")
         starFound = allStars.select{|star| star.user_id == current_user.id}
         return starFound.count
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         movieFound = Movie.find_by_id(params[:id])
         if(movieFound)
            guest = (!current_user && movieFound.reviewed && movieFound.bookgroup.name == "Peter Rabbit")
            if(current_user)
               visitTimer(type, movieFound)
               cleanupOldVisits
               owner = ((movieFound.user_id == current_user.id) || current_user.admin)
               visitor = (!owner && movieFound.reviewed && movieFound.bookgroup_id <= getBookGroups(current_user))
               movie = (owner && (movieFound.reviewed && movieFound.bookgroup_id <= getBookGroups(current_user)) || !movieFound.reviewed)
            end
            if((current_user && (movie || visitor)) || guest)
               @movie = movieFound
               @subplaylist = Subplaylist.find_by_id(movieFound.subplaylist_id)
               moviecomments = @movie.moviecomments.order("created_on desc")
               @moviecomments = Kaminari.paginate_array(moviecomments).page(params[:page]).per(10)
               stars = @movie.moviestars.count
               @stars = stars
               faves = @movie.favoritemovies.count
               @faves = faves
               if(type == "destroy")
                  logged_in = current_user
                  if(logged_in && ((logged_in.id == movieFound.user_id) || logged_in.admin))
                     flash[:success] = "#{@movie.title} was successfully removed."
                     @movie.destroy
                     if(logged_in.admin)
                        redirect_to movies_path
                     else
                        redirect_to mainplaylist_subplaylist_path(@subplaylist.mainplaylist, @subplaylist)
                     end
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         movieFound = Movie.find_by_id(params[:id])
         if(movieFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == movieFound.subplaylist.user_id) || movieFound.subplaylist.collab_mode) || logged_in.admin)
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @movie = movieFound
               @subplaylist = Subplaylist.find_by_id(movieFound.subplaylist_id)
               if(type == "update")
                  if(@movie.update_attributes(params[:movie]))
                     flash[:success] = "Movie #{@movie.title} was successfully updated."
                     redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
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
                  allMovies = Movie.order("created_on desc")
                  @movies = Kaminari.paginate_array(allMovies).page(params[:page]).per(9)
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
                  playlistFound = Subplaylist.find_by_id(params[:subplaylist_id])
                  if(playlistFound)
                     logged_in = current_user
                     if(logged_in && playlistFound.user_id == logged_in.id || (playlistFound.collab_mode && (playlistFound.bookgroup_id <= getBookGroups(logged_in))))
                        if(!playlistFound.fave_folder)
                           allGroups = Bookgroup.order("created_on desc")
                           allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                           @group = allowedGroups
                           newMovie = playlistFound.movies.new
                           if(type == "create")
                              newMovie = playlistFound.movies.new(params[:movie])
                              newMovie.created_on = currentTime
                              newMovie.user_id = logged_in.id
                           end
                           @movie = newMovie
                           @subplaylist = playlistFound
                           if(type == "create")
                              if(@movie.save)
                                 ContentMailer.movie_review(@movie).deliver
                                 flash[:success] = "Movie #{@movie.title} was successfully created."
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
            elsif(type == "review")
               logged_in = current_user
               if(logged_in)
                  allMovies = Movie.order("created_on desc")
                  pouchFound = Pouch.find_by_user_id(logged_in.id)
                  if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                     moviesToReview = allMovies.select{|movie| !movie.reviewed}
                     @movies = Kaminari.paginate_array(moviesToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "approve" || type == "deny")
               logged_in = current_user
               if(logged_in)
                  movieFound = Movie.find_by_id(params[:movie_id])
                  if(movieFound)
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                        if(type == "approve")
                           movieFound.reviewed = true
                           pouch = Pouch.find_by_user_id(movieFound.user_id)
                           pointsForMovie = 200
                           pouch.amount += pointsForMovie
                           @pouch = pouch
                           @pouch.save
                           @movie = movieFound
                           @movie.save
                           ContentMailer.movie_approved(@movie, pointsForMovie).deliver
                           allWatches = Watch.all
                           watchers = allWatches.select{|watch| (((watch.watchtype.name == "Movies" || watch.watchtype.name == "Blogmovies") || (watch.watchtype.name == "Artmovies" || watch.watchtype.name == "Moviesounds")) || (watch.watchtype.name == "Maincontent" || watch.watchtype.name == "All")) && watch.from_user.id != @movie.user_id}
                           if(watchers.count > 0)
                              watchers.each do |watch|
                                 UserMailer.new_movie(@movie, watch).deliver
                              end
                           end
                           value = "#{@movie.user.vname}'s movie #{@movie.title} was approved."
                        else
                           @movie = movieFound
                           ContentMailer.movie_denied(@movie).deliver
                           value = "#{@movie.user.vname}'s movie #{@movie.title} was denied."
                        end
                        flash[:success] = value
                        redirect_to movies_review_path
                     else
                        redirect_to root_path
                     end
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
