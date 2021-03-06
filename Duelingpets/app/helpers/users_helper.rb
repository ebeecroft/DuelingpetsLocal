module UsersHelper

   private
      def getReferredBy(user)
         referralFound = Referral.find_by_user_id(user.id)
         value = referralFound
         return value
      end

#@user.referral.from_user.vname
#@user.referral.from_user.vname, user_path(@user.referral.from_user)

      def getVisitors(timeframe, user)
         #Time values
         allVisits = user.uservisits.order("created_on desc")
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

      def getFriends(user, type)
         value = ""
         if(type == "Friends")
            allFriends = Friend.all
            userFriends = allFriends.select{|friend| friend.user_id == user.id || friend.from_user_id == user.id}
            value = userFriends.count
         else
            friend = ((current_user.friends.find_by_from_user_id(user.id)) || (user.friends.find_by_from_user_id(current_user.id)))
            value = friend
         end
         return value
      end

      def getFriendrequests(user)
         allFriends = Friend.all
         friend = allFriends.select{|friend| ((friend.from_user_id == user.id) && (friend.user_id == current_user.id)) || ((friend.user_id == user.id) && (friend.from_user_id == current_user.id))}
         value = ""
         if(friend.count > 0)
            value = "Friend"
         else
            #Setup request variables
            allRequests = Friendrequest.order("created_on desc")
            requestStatus = allRequests.select{|friend| friend.status == "Inprocess" || friend.status == "Approved"}
            userRequest = requestStatus.select{|friend| ((friend.user_id == user.id) && (friend.from_user_id == current_user.id)) || ((friend.user_id == current_user.id) && (friend.from_user_id == user.id))}
            if(userRequest.count == 0)
               value = "Not yet a friend"
            else
               value = userRequest.last.status
            end
         end
         return value
      end

      def getWatches(user, type)
         allWatches = Watch.all
         value = ""

         #Determines the type of watch that is being read
         if(type == "Watchers" || type == "Watching")
            userWatchers = allWatches.select{|watch| watch.user_id == user.id}
            if(type == "Watching")
               userWatchers = allWatches.select{|watch| watch.from_user_id == user.id}
            end
            value = userWatchers.count
         elsif(type == "Status" || type == "Watch")
            watch = user.watches.find_by_from_user_id(current_user.id)
            watchValue = "None"
            if(watch)
               watchValue = watch
               if(type == "Status")
                  watchValue = watch.watchtype.name
               end
            end
            value = watchValue
         end
         return value
      end

      def getReferrals(user)
         allReferrals = Referral.all
         userReferrals = allReferrals.select{|referral| referral.from_user_id == user.id}
         value = userReferrals.count
         return value
      end

      def getColorschemes(user)
         allUserColors = user.colorschemes.all
         value = allUserColors.count
         return value
      end

      def getForums(user)
         allUserForums = user.forums.all
         value = allUserForums.count
         return value
      end

      def getChannels(user)
         allUserChannels = user.channels.all
         value = allUserChannels.count
         return value
      end

      def getGalleries(user)
         allUserGalleries = user.galleries.all
         value = allUserGalleries.count
         return value
      end

      def getRadios(user)
         allUserRadios = user.radiostations.all
         value = allUserRadios.count
         return value
      end

      def getTopicContainers(user)
         allContainers = Topiccontainer.all
         userContainers = allContainers.select{|container| container.user_id == user.id}
         value = userContainers.count
         return value
      end

      def getMaintopics(user)
         allMaintopics = Maintopic.all
         userTopics = allMaintopics.select{|maintopic| maintopic.user_id == user.id}
         value = userTopics.count
         return value
      end

      def getSubtopics(user)
         allSubtopics = Subtopic.all
         userTopics = allSubtopics.select{|subtopic| subtopic.user_id == user.id}
         value = userTopics.count
         return value
      end

      def getNarratives(user)
         allNarratives = Narrative.all
         userNarratives = allNarratives.select{|narrative| narrative.user_id == user.id}
         value = userNarratives.count
         return value
      end

      def getMovies(user)
         allMovies = Movie.all
         reviewedMovies = allMovies.select{|movie| movie.reviewed && movie.user_id == user.id}
         value = reviewedMovies.count
         return value
      end

      def getArts(user)
         allArts = Art.all
         reviewedArts = allArts.select{|artwork| artwork.reviewed && artwork.user_id == user.id}
         value = reviewedArts.count
         return value
      end

      def getSounds(user)
         allSounds = Sound.all
         reviewedSounds = allSounds.select{|sound| sound.reviewed && sound.user_id == user.id}
         value = reviewedSounds.count
         return value
      end

      def getBlogStars(user)
         allStars = Blogstar.all
         userStars = allStars.select{|star| star.user_id == user.id}
         value = userStars.count
         return value
      end

      def getBlogComments(user)
         allComments = Reply.all
         userComments = allComments.select{|comment| comment.user_id == user.id}
         value = userComments.count
         return value
      end

      def getArtFaves(user)
         allFaves = Favoriteart.all
         userFaves = allFaves.select{|fave| fave.user_id == user.id}
         value = userFaves.count
         return value
      end

      def getArtStars(user)
         allStars = Artstar.all
         userStars = allStars.select{|star| star.user_id == user.id}
         value = userStars.count
         return value
      end

      def getArtCritiques(user)
         allCritiques = Artcomment.all
         userCritiques = allCritiques.select{|comment| comment.user_id == user.id && comment.critique}
         value = userCritiques.count
         return value
      end

      def getArtComments(user)
         allComments = Artcomment.all
         userComments = allComments.select{|comment| comment.user_id == user.id && !comment.critique}
         value = userComments.count
         return value
      end

      def getMovieFaves(user)
         allFaves = Favoritemovie.all
         userFaves = allFaves.select{|fave| fave.user_id == user.id}
         value = userFaves.count
         return value
      end

      def getMovieStars(user)
         allStars = Moviestar.all
         userStars = allStars.select{|star| star.user_id == user.id}
         value = userStars.count
         return value
      end

      def getMovieCritiques(user)
         allCritiques = Moviecomment.all
         userCritiques = allCritiques.select{|comment| comment.user_id == user.id && comment.critique}
         value = userCritiques.count
         return value
      end

      def getMovieComments(user)
         allComments = Moviecomment.all
         userComments = allComments.select{|comment| comment.user_id == user.id && !comment.critique}
         value = userComments.count
         return value
      end

      def getSoundFaves(user)
         allFaves = Favoritesound.all
         userFaves = allFaves.select{|fave| fave.user_id == user.id}
         value = userFaves.count
         return value
      end

      def getSoundStars(user)
         allStars = Soundstar.all
         userStars = allStars.select{|star| star.user_id == user.id}
         value = userStars.count
         return value
      end

      def getSoundCritiques(user)
         allCritiques = Soundcomment.all
         userCritiques = allCritiques.select{|comment| comment.user_id == user.id && comment.critique}
         value = userCritiques.count
         return value
      end

      def getSoundComments(user)
         allComments = Soundcomment.all
         userComments = allComments.select{|comment| comment.user_id == user.id && !comment.critique}
         value = userComments.count
         return value
      end

      def getBlogs(user)
         allUserBlogs = user.blogs.all
         reviewedBlogs = allUserBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s == "" && blog.largeimage1.to_s == "" && blog.largeimage2.to_s == "" && blog.largeimage3.to_s == "" && blog.smallimage1.to_s == "" && blog.smallimage2.to_s == "" && blog.smallimage3.to_s == "" && blog.smallimage4.to_s == "" && blog.smallimage5.to_s == ""}
         value = reviewedBlogs.count
         return value
      end

      def getAdBlogs(user)
         allUserBlogs = user.blogs.all
         adBlogs = allUserBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s != "" || blog.largeimage1.to_s != "" || blog.largeimage2.to_s != "" || blog.largeimage3.to_s != "" || blog.smallimage1.to_s != "" || blog.smallimage2.to_s != "" || blog.smallimage3.to_s != "" || blog.smallimage4.to_s != "" || blog.smallimage5.to_s != ""}
         value = adBlogs.count
         return value
      end

      def getUserPrivilege(user)
         if(user.admin)
            value = "@"
         else
            pouchFound = Pouch.find_by_user_id(user.id)
            if(pouchFound)
               type = pouchFound.privilege
               if(type == "Keymaster")
                  value = "$"
               elsif(type == "Reviewer")
                  value = "^"
               elsif(type == "Beta")
                  value = "%"
               elsif(type == "Banned")
                  value = "!"
               elsif(type == "Trial")
                  value = "?"
               else
                  value = "~"
               end
            else
               value = "~"
            end
         end
         return value
      end

      def getShouts(userFound)
         allShouts = Shout.order("created_on desc")
         shouts = allShouts.select{|shout| shout.user_id == userFound.id}
         @shouts = Kaminari.paginate_array(shouts).page(params[:page]).per(10)
      end

      def getActivity(user)
         status = "Inoperable"
         userPouch = Pouch.find_by_id(user.id)
         if(userPouch.activated)
            if(!userPouch.signed_out_at)
               if(!userPouch.signed_in_at)
                  status = "Inoperable"
               elsif((currentTime - userPouch.last_visited) > 30.minutes)
                  status = "Inactive"
               else
                  status = "Online"
               end
            else
               status = "Offline"
            end
         end         
         return status
      end

      def getTime(user)
         value = ""
         userPouch = Pouch.find_by_id(user.id)
         if(getActivity(user) == "Inactive")
            value = userPouch.last_visited
         elsif(getActivity(user) == "Offline")
            value = userPouch.signed_out_at
         end
         return value
      end

      def getGroup(user)
         if(user.birthday)
            age = (currentTime.year - user.birthday.year)
            monthValue = (currentTime.month - user.birthday.month) / 12
            if(monthValue < 0)
              age -= 1
            end
            group = ""
            if(age < 7)
               group = "Babbity"
            elsif(age >= 7 && age <= 12)
               group = "Peter Rabbit"
            elsif(age >= 13 && age <= 18)
               group = "Dragons Of BlueLand"
            elsif(age >= 19 && age <= 24)
               group = "The Dragon and the George"
            elsif(age >= 25 && age <= 30)
               group = "Silverwing"
            elsif(age >= 31 && age <= 36)
               group = "Harahpin"
            elsif(age > 36)
               group = "LOTR"
            end
         end
         return group
      end

      def musicCommons(type)
         userFound = User.find_by_id(params[:id])
         if(userFound)
            if(type == "gmusiccontrol")
               music_value = ""
               if(checkMusicFlag == "On")
                  music_value = "Off"
               else
                  music_value = "On"
               end
               cookies[:music_on] = {:value => music_value}
               @user = userFound
               redirect_to user_path(@user)
            else
               if(current_user && current_user.id == userFound.id)
                  userInfo = Userinfo.find_by_user_id(userFound.id)
                  if(userInfo.music_on)
                     userInfo.music_on = false
                  else
                     userInfo.music_on = true
                  end
                  @userinfo = userInfo
                  @userinfo.save
                  redirect_to user_path(@userinfo.user)
               end
            end
         else
            render "start/crazybat"
         end
      end

      def editCommons(type)
         userFound = User.find_by_vname(params[:id])
         if(userFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == userFound.id) || logged_in.admin))
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @user = userFound
               if(type == "update")
                  if(@user.update_attributes(params[:user]))
                     flash[:success] = "#{@user.vname} was successfully updated."
                     redirect_to @user
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

      def cleanupOldVisits
         allVisits = Uservisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @uservisit = visit
               @uservisit.destroy
            end
         end
      end

      def saveVisit(userFound, visitor)
         allVisits = userFound.uservisits.order("created_on desc")
         userVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.minutes) && (visit.from_user_id == visitor.id)}
         if(userVisited.count == 0)
            #Add visitor to list
            newVisit = userFound.uservisits.new(params[:uservisit])
            newVisit.from_user_id = visitor.id
            newVisit.created_on = currentTime
            @uservisit = newVisit
            @uservisit.save
         end
      end

      def visitTimer(type, userFound)
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
               if(visitor.id != userFound.id && !visitor.admin)
                  timer = Pagetimer.find_by_name("User")
                  if(timer.expiretime - currentTime <= 0)
                     value = timer.duration.minutes.from_now.utc
                     timer.expiretime = value
                     @pagetimer = timer
                     @pagetimer.save
                     saveVisit(userFound, visitor)
                  else
                     saveVisit(userFound, visitor)
                  end
               end
            end
         end
      end

      def showCommons(type)
         userFound = User.find_by_vname(params[:id])
         if(userFound)
            visitTimer(type, userFound)
            cleanupOldVisits
            @user = userFound
            if(type == "destroy")
               logged_in = current_user
               if(logged_in && ((logged_in.id == userFound.id) || logged_in.admin))
                  adminXorCurrentUser = (logged_in.admin && logged_in.id != userFound.id) || (!logged_in.admin && logged_in.id == userFound.id)
                  if(adminXorCurrentUser)
                     allColors = Colorscheme.all
                     allInfos = Userinfo.all
                     userColors = allColors.select{|colorscheme| colorscheme.user_id == @user.id}
                     if(userColors.size != 0)
                        userColors.each do |colorscheme|
                           infosToChange = allInfos.select{|userinfo| userinfo.colorscheme_id == colorscheme.id}
                           if(infosToChange.size != 0)
                              infosToChange.each do |userinfo|
                                 userinfo.colorscheme_id = 1
                                 @userinfo = userinfo
                                 @userinfo.save
                              end
                           end
                        end
                     end
                     @user.destroy
                     flash[:success] = "#{@user.vname} was successfully removed."
                     if(logged_in.admin)
                        redirect_to users_url
                     else
                        redirect_to root_path
                     end
                  else
                     flash[:error] = "You cannot delete the main admin account."
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
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
                  allUsers = User.order("joined_on desc").page(params[:page]).per(10)
                  @users = allUsers
               else
                  redirect_to root_path
               end
            elsif(type == "edit" || type == "update")
               if(current_user && current_user.admin)
                  editCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  userMode = Maintenancemode.find_by_id(5)
                  if(allMode.maintenance_on || userMode.maintenance_on)
                     if(allMode.maintenance_on)
                        #the render section
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            elsif(type == "show" || type == "destroy")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(current_user && current_user.admin)
                     showCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  end
               else
                  showCommons(type)
               end
            elsif(type == "musiccontrol" || "gmusiccontrol")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(current_user && current_user.admin)
                     musicCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  end
               else
                  musicCommons(type)
               end
            end
         end
      end
end
