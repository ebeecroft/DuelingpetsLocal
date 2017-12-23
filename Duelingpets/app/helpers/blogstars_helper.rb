module BlogstarsHelper

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
                  allStars = Blogstar.order("created_on desc")
                  @blogstars = Kaminari.paginate_array(allStars).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "star")
               allMode = Maintenancemode.find_by_id(1)
               blogMode = Maintenancemode.find_by_id(6)
               if(allMode.maintenance_on || blogMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/blogs/maintenance"
                  end
               else
                  blogFound = Blog.find_by_id(params[:blog_id])
                  if(blogFound)
                     logged_in = current_user
                     if(logged_in && (blogFound.user_id != logged_in.id))
                        allStars = blogFound.blogstars.order("created_on desc")
                        starFound = allStars.select{|star| star.user_id == logged_in.id}
                        if(starFound.count > 0)
                           #Destroy
                           @blogstar = Blogstar.find_by_id(starFound)
                           @blog = blogFound
                           flash[:success] = "Star was successfully removed."
                           @blogstar.destroy
                           redirect_to user_blog_path(@blog.user, @blog)
                        else
                           #Create
                           newStar = blogFound.blogstars.new(params[:blogstar])
                           newStar.created_on = currentTime
                           newStar.user_id = logged_in.id
                           @blogstar = newStar
                           @blog = blogFound
                           if(@blogstar.save)
                              pouch = Pouch.find_by_user_id(blogFound.user_id)
                              pointsForStar = 20
                              pouch.amount += pointsForStar
                              UserMailer.blog_starred(@blogstar, pointsForStar).deliver
                              @pouch = pouch
                              @pouch.save
                              flash[:success] = "A new star was successfully created."
                              redirect_to user_blog_path(@blog.user, @blog)
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
                  starFound = Blogstar.find_by_id(params[:id])
                  if(starFound)
                     @blogstar = starFound
                     @blog = Blog.find_by_id(starFound.blog_id)
                     flash[:success] = "Star by #{@blogstar.user.vname} was successfully removed."
                     @blogstar.destroy
                     redirect_to blogstars_path
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
