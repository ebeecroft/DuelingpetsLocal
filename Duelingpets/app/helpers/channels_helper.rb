module ChannelsHelper

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

      def getSubplaylists(mainplaylist)
         mainplaylistSubplaylists = mainplaylist.subplaylists.order("created_on desc")
         subplaylists = mainplaylistSubplaylists.select{|subplaylist| (((!current_user && subplaylist.bookgroup.name == "Peter Rabbit") || (current_user && subplaylist.bookgroup_id <= getBookGroups(current_user))) && subplaylist.movies.count > 0) || (current_user && subplaylist.bookgroup_id <= getBookGroups(current_user) && (((current_user.id == subplaylist.user_id) || current_user.admin) || subplaylist.collab_mode))}
         mainplaylist.subplaylists.each do |subplaylist|
            getCollabs
            if(subplaylist.collab_mode)
               collabCounter(1)
            end
         end

         return subplaylists
      end

      def collabCounter(count)
         @collabcount += count
      end

      def getCollabs
         if(@collabcount.nil?)
            @collabcount = 0
         end
         @collabcount
      end

      def showCommons(type)
         logged_in2 = current_user
         if(logged_in2)
            userPouch = Pouch.find_by_user_id(logged_in2.id)
            userPouch.last_visited = currentTime
            @pouch = userPouch
            @pouch.save
         end
         channelFound = Channel.find_by_name(params[:id])
         if(channelFound)
            userFound = User.find_by_vname(params[:user_id])
            if(userFound && channelFound.user_id == userFound.id)
               channelMainlists = channelFound.mainplaylists.order("created_on desc")
               playlists = channelMainlists.select{|mainplaylist| mainplaylist.subplaylists.count > 0 || (current_user && (current_user.id == mainplaylist.user_id) || current_user.admin)}
               if(playlists.count > 0 || current_user && ((current_user.id == channelFound.user_id) || current_user.admin))
                  @channel = channelFound
                  @mainplaylists = Kaminari.paginate_array(playlists).page(params[:page]).per(9)
                  if(type == "destroy")
                     logged_in = current_user
                     if(logged_in && ((logged_in.id == channelFound.user_id) || logged_in.admin))
                        flash[:success] = "#{@channel.name} was successfully removed."
                        @channel.destroy
                        if(logged_in.admin)
                           redirect_to channels_list_path
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
         channelFound = Channel.find_by_name(params[:id])
         if(channelFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == channelFound.user_id) || logged_in.admin))
               @channel = channelFound
               @user = User.find_by_vname(channelFound.user.vname)
               if(type == "update")
                  if(@channel.update_attributes(params[:channel]))
                     flash[:success] = "#{@channel.name} was successfully updated."
                     redirect_to user_channel_path(@user, @channel)
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

      def optional
         value = params[:user_id]
         return value
      end

      def indexCommons
         if(optional)
            userFound = User.find_by_vname(optional)
            if(userFound)
               allChannels = userFound.channels.order("created_on desc")
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allChannels = Channel.order("created_on desc")
         end
         @channels = Kaminari.paginate_array(allChannels).page(params[:page]).per(10)
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               if(current_user && current_user.admin)
                  indexCommons
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
                     indexCommons
                  end
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
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newChannel = logged_in.channels.new
                        if(type == "create")
                           newChannel = logged_in.channels.new(params[:channel])
                           newChannel.created_on = currentTime
                        end
                        @user = userFound
                        @channel = newChannel
                        if(type == "create")
                           if(@channel.save)
                              flash[:success] = "#{@channel.name} was successfully created."
                              redirect_to user_channel_path(@user, @channel)
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
            elsif(type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allChannels = Channel.order("created_on desc")
                  @channels = Kaminari.paginate_array(allChannels).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            end
         end
      end
end
