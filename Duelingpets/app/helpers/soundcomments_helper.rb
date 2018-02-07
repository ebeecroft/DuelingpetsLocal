module SoundcommentsHelper

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
         commentFound = Soundcomment.find_by_id(params[:id])
         if(commentFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == commentFound.user_id) || logged_in.admin))
               @soundcomment = commentFound
               @sound = Sound.find_by_id(commentFound.sound_id)
               if(type == "update")
                  if(@soundcomment.update_attributes(params[:soundcomment]))
                     flash[:success] = "Comment by #{@soundcomment.user.vname} was successfully updated."
                     redirect_to subfolder_art_path(@sound.subsheet, @sound)
                  else
                     render "edit"
                  end
               elsif(type == "destroy")
                  flash[:success] = "Comment by #{@soundcomment.user.vname} was successfully removed."
                  @soundcomment.destroy
                  if(logged_in.admin)
                     redirect_to soundcomments_path
                  else
                     redirect_to subsheet_sound_path(@sound.subsheet, @sound)
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
                  allComments = Soundcomment.order("created_on desc")
                  @soundcomments = Kaminari.paginate_array(allComments).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               radioMode = Maintenancemode.find_by_id(9)
               if(allMode.maintenance_on || radioMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/radiostations/maintenance"
                  end
               else
                  soundFound = Sound.find_by_id(params[:sound_id])
                  if(soundFound)
                     logged_in = current_user
                     if(logged_in)
                        groupAccess = soundFound.bookgroup_id <= getBookGroups(logged_in)
                        if(groupAccess == true)
                           newComment = soundFound.soundcomments.new
                           if(type == "create")
                              newComment = soundFound.soundcomments.new(params[:soundcomment])
                              newComment.created_on = currentTime
                              newComment.user_id = logged_in.id
                           end
                           if(((newComment.user_id != soundFound.user_id) && newComment.critique) || !newComment.critique)
                              @soundcomment = newComment
                              @sound = soundFound
                              if(type == "create")
                                 if(@soundcomment.save)
                                    if(@soundcomment.critique)
                                       #Mailer dependent on critique
                                       pouch = Pouch.find_by_user_id(soundFound.user_id)
                                       pointsForCritique = 12
                                       pouch.amount += pointsForCritique
                                       UserMailer.sound_critiqued(@soundcomment, pointsForCritique).deliver
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                    flash[:success] = "Comment by #{@soundcomment.user.vname} was successfully created."
                                    redirect_to subsheet_sound_path(@sound.subsheet, @sound)
                                 else
                                    render "new"
                                 end
                              end
                           else
                              flash[:error] = "You can't critique your own sound!"
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
                  radioMode = Maintenancemode.find_by_id(9)
                  if(allMode.maintenance_on || radioMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/radiostations/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            end
         end
      end
end
