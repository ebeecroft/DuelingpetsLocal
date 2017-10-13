module PouchesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allPouches = Pouch.order("signed_in_at desc").page(params[:page]).per(10)
                  @pouches = allPouches
               else
                  redirect_to root_path
               end
            elsif(type == "edit" || type == "update")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  pouchFound = Pouch.find_by_id(params[:id])
                  if(pouchFound)
                     @pouch = pouchFound
                     if(type == "update")
                        if(@pouch.update_attributes(params[:pouch]))
                           flash[:success] = "#{@pouch.user.vname} privilege was successfully updated."
                           redirect_to pouches_path
                        else
                           render "edit"
                        end
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
