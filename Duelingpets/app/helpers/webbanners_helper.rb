module WebbannersHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allBanners = Webbanner.order("created_on desc")
                  @webbanners = Kaminari.paginate_array(allBanners).page(params[:page]).per(10)
               elsif(type == "edit" || type == "update")
                  bannerFound = Webbanner.find_by_name(params[:id])
                  if(bannerFound)
                     @webbanner = bannerFound
                     if(type == "update")
                        if(@webbanner.update_attributes(params[:webbanner]))
                           flash[:success] = "The webbanner #{@webbanner.name} was successfully updated."
                           redirect_to webbanners_path
                        else
                           render "edit"
                        end
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
