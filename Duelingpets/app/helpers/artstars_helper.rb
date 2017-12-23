module ArtstarsHelper

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
                  allStars = Artstar.order("created_on desc")
                  @artstars = Kaminari.paginate_array(allStars).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "star")
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
                        allStars = artFound.artstars.order("created_on desc")
                        starFound = allStars.select{|star| star.user_id == logged_in.id}
                        if(starFound.count > 0)
                           #Destroy
                           @artstar = Artstar.find_by_id(starFound)
                           @art = artFound
                           flash[:success] = "Star was successfully removed."
                           @artstar.destroy
                           redirect_to subfolder_art_path(@art.subfolder, @art)
                        else
                           #Create
                           newStar = artFound.artstars.new(params[:artstar])
                           newStar.created_on = currentTime
                           newStar.user_id = logged_in.id
                           @artstar = newStar
                           @art = artFound
                           if(@artstar.save)
                              pouch = Pouch.find_by_user_id(artFound.user_id)
                              pointsForStar = 48
                              pouch.amount += pointsForStar
                              UserMailer.art_starred(@artstar, pointsForStar).deliver
                              @pouch = pouch
                              @pouch.save
                              flash[:success] = "A new star was successfully created."
                              redirect_to subfolder_art_path(@art.subfolder, @art)
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
                  starFound = Artstar.find_by_id(params[:id])
                  if(starFound)
                     @artstar = starFound
                     @art = Art.find_by_id(starFound.art_id)
                     flash[:success] = "Star by #{@artstar.user.vname} was successfully removed."
                     @artstar.destroy
                     redirect_to artstars_path
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
