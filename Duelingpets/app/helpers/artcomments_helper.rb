module ArtcommentsHelper

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
         commentFound = Artcomment.find_by_id(params[:id])
         if(commentFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == commentFound.user_id) || logged_in.admin))
               @artcomment = commentFound
               @art = Art.find_by_id(commentFound.art_id)
               if(type == "update")
                  if(@artcomment.update_attributes(params[:artcomment]))
                     flash[:success] = "Comment by #{@artcomment.user.vname} was successfully updated."
                     redirect_to subfolder_art_path(@art.subfolder, @art)
                  else
                     render "edit"
                  end
               elsif(type == "destroy")
                  flash[:success] = "Comment by #{@artcomment.user.vname} was successfully removed."
                  @artcomment.destroy
                  if(logged_in.admin)
                     redirect_to artcomments_path
                  else
                     redirect_to subfolder_art_path(@art.subfolder, @art)
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
                  allComments = Artcomment.order("created_on desc")
                  @artcomments = Kaminari.paginate_array(allComments).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(7)
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
                     if(logged_in)
                        groupAccess = artFound.bookgroup_id <= getBookGroups(logged_in)
                        if(groupAccess == true)
                           newComment = artFound.artcomments.new
                           if(type == "create")
                              newComment = artFound.artcomments.new(params[:artcomment])
                              newComment.created_on = currentTime
                              newComment.user_id = logged_in.id
                           end
                           if(((newComment.user_id != artFound.user_id) && newComment.critique) || !newComment.critique)
                              @artcomment = newComment
                              @art = artFound
                              if(type == "create")
                                 if(@artcomment.save)
                                    if(@artcomment.critique)
                                       #Mailer dependent on critique
                                       pouch = Pouch.find_by_user_id(artFound.user_id)
                                       pointsForCritique = 12
                                       pouch.amount += pointsForCritique
                                       UserMailer.art_critiqued(@artcomment, pointsForCritique).deliver
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                    flash[:success] = "Comment by #{@artcomment.user.vname} was successfully created."
                                    redirect_to subfolder_art_path(@art.subfolder, @art)
                                 else
                                    render "new"
                                 end
                              end
                           else
                              flash[:error] = "You can't critique your own art!"
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
                  galleryMode = Maintenancemode.find_by_id(8)
                  if(allMode.maintenance_on || galleryMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/galleries/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            end
         end
      end
end
