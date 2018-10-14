module ArtvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Artvisit.find_by_id(params[:id])
               if(visitFound)
                  @artvisit = visitFound
                  flash[:success] = "Artvisit was successfully removed."
                  @artvisit.destroy
                  redirect_to artvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Artvisit.order("created_on desc")
               @artvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
            end
         else
            redirect_to root_path
         end
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
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
                     artVisits = artFound.artvisits.order("created_on desc")
                     @art = artFound
                     @artvisits = Kaminari.paginate_array(artVisits).page(params[:page]).per(10)
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy" || type == "visitlist")
               destroyCommons(type)
            end
         end
      end
end
