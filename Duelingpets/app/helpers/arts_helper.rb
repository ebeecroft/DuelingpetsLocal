module ArtsHelper

   private
      def retrieveArtFave(art, type)
         allFaves = art.favoritearts.order("created_on desc")
         faveFound = allFaves.select{|fave| fave.user_id == current_user.id}
         favorite = Favoriteart.find_by_id(faveFound)
         fave = favorite
         if(type == "Count")
            fave = faveFound
         end
         return fave
      end

      def retrieveArtStar(art)
         allStars = art.artstars.order("created_on desc")
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
         artFound = Art.find_by_id(params[:id])
         if(artFound)
            guest = (!current_user && artFound.reviewed && artFound.bookgroup.name == "Peter Rabbit")
            if(current_user)
               owner = ((artFound.user_id == current_user.id) || current_user.admin)
               visitor = (!owner && artFound.reviewed && artFound.bookgroup_id <= getBookGroups(current_user))
               art = (owner && (artFound.reviewed && artFound.bookgroup_id <= getBookGroups(current_user)) || !artFound.reviewed)
            end
            if((current_user && (art || visitor)) || guest)
               @art = artFound
               @subfolder = Subfolder.find_by_id(artFound.subfolder_id)
               artcomments = @art.artcomments.order("created_on desc")
               @artcomments = Kaminari.paginate_array(artcomments).page(params[:page]).per(10)
               stars = @art.artstars.count
               @stars = stars
               faves = @art.favoritearts.count
               @faves = faves
               if(type == "destroy")
                  logged_in = current_user
                  if(logged_in && ((logged_in.id == artFound.user_id) || logged_in.admin))
                     flash[:success] = "#{@art.title} was successfully removed."
                     @art.destroy
                     if(logged_in.admin)
                        redirect_to arts_path
                     else
                        redirect_to mainfolder_subfolder_path(@subfolder.mainfolder, @subfolder)
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
         artFound = Art.find_by_id(params[:id])
         if(artFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == artFound.subfolder.user_id) || artFound.subfolder.collab_mode) || logged_in.admin)
               allGroups = Bookgroup.order("created_on desc")
               allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
               @group = allowedGroups
               @art = artFound
               @subfolder = Subfolder.find_by_id(artFound.subfolder_id)
               if(type == "update")
                  if(@art.update_attributes(params[:art]))
                     flash[:success] = "Art #{@art.title} was successfully updated."
                     redirect_to subfolder_art_path(@art.subfolder, @art)
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
                  allArts = Art.order("created_on desc")
                  @arts = Kaminari.paginate_array(allArts).page(params[:page]).per(9)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               galleryMode = Maintenancemode.find_by_id(8)
               if(allMode.maintenance_on || galleryMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/galleries/maintenance"
                  end
               else
                  folderFound = Subfolder.find_by_id(params[:subfolder_id])
                  if(folderFound)
                     logged_in = current_user
                     if(logged_in && folderFound.user_id == logged_in.id || (folderFound.collab_mode && (folderFound.bookgroup_id <= getBookGroups(logged_in))))
                        if(!folderFound.fave_folder)
                           allGroups = Bookgroup.order("created_on desc")
                           allowedGroups = allGroups.select{|bookgroup| bookgroup.id <= getBookGroups(logged_in)}
                           @group = allowedGroups
                           newArt = folderFound.arts.new
                           if(type == "create")
                              newArt = folderFound.arts.new(params[:art])
                              newArt.created_on = currentTime
                              newArt.user_id = logged_in.id
                           end
                           @art = newArt
                           @subfolder = folderFound
                           if(type == "create")
                              if(@art.save)
                                 ContentMailer.art_review(@art).deliver
                                 flash[:success] = "Art #{@art.title} was successfully created."
                                 redirect_to subfolder_art_path(@art.subfolder, @art)
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
            elsif(type == "show" || type == "destroy")
               if(current_user && current_user.admin)
                  showCommons(type)
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
                     showCommons(type)
                  end
               end
            elsif(type == "review")
               logged_in = current_user
               if(logged_in)
                  allArts = Art.order("created_on desc")
                  pouchFound = Pouch.find_by_user_id(logged_in.id)
                  if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                     artsToReview = allArts.select{|art| !art.reviewed}
                     @arts = Kaminari.paginate_array(artsToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "approve" || type == "deny")
               logged_in = current_user
               if(logged_in)
                  artFound = Art.find_by_id(params[:art_id])
                  if(artFound)
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                        if(type == "approve")
                           artFound.reviewed = true
                           pouch = Pouch.find_by_user_id(artFound.user_id)
                           pointsForArt = 200
                           pouch.amount += pointsForArt
                           @pouch = pouch
                           @pouch.save
                           @art = artFound
                           @art.save
                           ContentMailer.art_approved(@art, pointsForArt).deliver
                           allWatches = Watch.all
                           watchers = allWatches.select{|watch| (((watch.watchtype.name == "Arts" || watch.watchtype.name == "Blogarts") || (watch.watchtype.name == "Artsounds" || watch.watchtype.name == "Artmovies")) || (watch.watchtype.name == "Maincontent" || watch.watchtype.name == "All")) && watch.from_user.id != @art.user_id}
                           if(watchers.count > 0)
                              watchers.each do |watch|
                                 UserMailer.new_art(@art, watch).deliver
                              end
                           end
                           value = "#{@art.user.vname}'s art #{@art.title} was approved."
                        else
                           @art = artFound
                           ContentMailer.art_denied(@art).deliver
                           value = "#{@art.user.vname}'s art #{@art.title} was denied."
                        end
                        flash[:success] = value
                        redirect_to arts_review_path
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

