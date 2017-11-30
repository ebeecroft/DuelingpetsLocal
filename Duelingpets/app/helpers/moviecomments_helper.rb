module MoviecommentsHelper

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

      def editCommons(type)
         commentFound = Moviecomment.find_by_id(params[:id])
         if(commentFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == commentFound.user_id) || logged_in.admin))
               @moviecomment = commentFound
               @movie = Movie.find_by_id(commentFound.movie_id)
               if(type == "update")
                  if(@moviecomment.update_attributes(params[:moviecomment]))
                     flash[:success] = "Comment by #{@moviecomment.user.vname} was successfully updated."
                     redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
                  else
                     render "edit"
                  end
               elsif(type == "destroy")
                  flash[:success] = "Comment by #{@moviecomment.user.vname} was successfully removed."
                  @moviecomment.destroy
                  if(logged_in.admin)
                     redirect_to moviecomments_path
                  else
                     redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
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
                  allComments = Moviecomment.order("created_on desc")
                  @moviecomments = Kaminari.paginate_array(allComments).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(7)
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
                     if(logged_in)
                        groupAccess = movieFound.bookgroup_id <= getBookGroups(logged_in)
                        if(groupAccess == true)
                           newComment = movieFound.moviecomments.new
                           if(type == "create")
                              newComment = movieFound.moviecomments.new(params[:moviecomment])
                              newComment.created_on = currentTime
                              newComment.user_id = logged_in.id
                           end
                           if(((newComment.user_id != movieFound.user_id) && newComment.critique) || !newComment.critique)
                              @moviecomment = newComment
                              @movie = movieFound
                              if(type == "create")
                                 if(@moviecomment.save)
                                    if(@moviecomment.critique)
                                       #Mailer dependent on critique
                                       pouch = Pouch.find_by_user_id(movieFound.user_id)
                                       pointsForCritique = 12
                                       pouch.amount += pointsForCritique
                                       UserMailer.movie_critiqued(@moviecomment, pointsForCritique).deliver
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                    flash[:success] = "Comment by #{@moviecomment.user.vname} was successfully created."
                                    redirect_to subplaylist_movie_path(@movie.subplaylist, @movie)
                                 else
                                    render "new"
                                 end
                              end
                           else
                              flash[:error] = "You can't critique your own movie!"
                              render "new"
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
            elsif(type == "edit" || type == "update" || type == "destroy")
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
            end
         end
      end
end
