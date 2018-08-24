module ArtpagesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allArts = Artpage.order("created_on desc")
                  @artpages = Kaminari.paginate_array(allArts).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newArt = Artpage.new
                  if(type == "create")
                     newArt = Artpage.new(params[:artpage])
                     newArt.created_on = currentTime
                  end
                  @artpage = newArt
                  if(type == "create")
                     if(@artpage.save)
                        flash[:success] = "The artpage #{@artpage.name} has been successfully created."
                        redirect_to artpages_path
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  artFound = Artpage.find_by_name(params[:id])
                  if(artFound)
                     @artpage = artFound
                     if(type == "update")
                        if(@artpage.update_attributes(params[:artpage]))
                           flash[:success] = "The artpage #{@artpage.name} was successfully updated."
                           redirect_to artpages_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "The artpage #{@artpage.name} was successfully removed."
                        @artpage.destroy
                        redirect_to artpages_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
