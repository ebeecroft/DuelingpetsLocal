module UsersHelper

   private
      def getReferrals(user)
         allReferrals = Referral.all
         userReferrals = allReferrals.select{|referral| referral.referred_by_id == user.id}
         value = userReferrals.count
         return value
      end

      def getColorschemePoints(user)
         colorsFound = getColorschemes(user)
         value = colorsFound * 12
         return value
      end

      def getColorschemes(user)
         allUserColors = user.colorschemes.all
         value = allUserColors.count
         return value
      end

      def getChannels(user)
         allUserChannels = user.channels.all
         value = allUserChannels.count
         return value
      end

      def getBlogs(user)
         allUserBlogs = user.blogs.all
         reviewedBlogs = allUserBlogs.select{|blog| blog.reviewed}
         value = reviewedBlogs.count
         return value
      end

      def getAdBlogs(user)
         allUserBlogs = user.blogs.all
         adBlogs = allUserBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s != "" || blog.largeimage1.to_s != "" || blog.largeimage2.to_s != "" || blog.largeimage3.to_s != "" || blog.smallimage1.to_s != "" || blog.smallimage2.to_s != "" || blog.smallimage3.to_s != "" || blog.smallimage4.to_s != "" || blog.smallimage5.to_s != ""}
         value = adBlogs.count
         return value
      end

      def getBlogPoints(user)
         allUserBlogs = user.blogs.all
         blogsWithoutAds = allUserBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s == "" && blog.largeimage1.to_s == "" && blog.largeimage2.to_s == "" && blog.largeimage3.to_s == "" && blog.smallimage1.to_s == "" && blog.smallimage2.to_s == "" && blog.smallimage3.to_s == "" && blog.smallimage4.to_s == "" && blog.smallimage5.to_s == ""}
         textblogs = blogsWithoutAds.select{|blog| blog.admascot == ""}
         mascot = blogsWithoutAds.select{|blog| blog.admascot != ""}
         value = (textblogs.count * 30) + (mascot.count * 90)
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

      def showCommons(type)
         #Show page can be accessed by guest, logged in and admins
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         userFound = User.find_by_vname(params[:id])
         if(userFound)
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
