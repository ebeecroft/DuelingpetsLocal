module GalleryvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Galleryvisit.find_by_id(params[:id])
               if(visitFound)
                  @galleryvisit = visitFound
                  flash[:success] = "Galleryvisit was successfully removed."
                  @galleryvisit.destroy
                  redirect_to galleryvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Galleryvisit.order("created_on desc")
               @galleryvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
                  galleryFound = Gallery.find_by_name(params[:gallery_id])
                  if(galleryFound)
                     galleryVisits = galleryFound.galleryvisits.order("created_on desc")
                     @gallery = galleryFound
                     @galleryvisits = Kaminari.paginate_array(galleryVisits).page(params[:page]).per(10)
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
