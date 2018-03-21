module BlacklistednamesHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allNames = Blacklistedname.order("created_on desc")
                  @blacklistednames = Kaminari.paginate_array(allNames).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newName = Blacklistedname.new
                  if(type == "create")
                     newName = Blacklistedname.new(params[:blacklistedname])
                     newName.created_on = currentTime
                  end
                  @blacklistedname = newName
                  if(type == "create")
                     if(@blacklistedname.save)
                        flash[:success] = "The name #{@blacklistedname.name} has been added to the blacklist!"
                        redirect_to blacklistednames_path
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  nameFound = Blacklistedname.find_by_name(params[:id])
                  if(nameFound)
                     @blacklistedname = nameFound
                     if(type == "update")
                        if(@blacklistedname.update_attributes(params[:blacklistedname]))
                           flash[:success] = "The name #{@blacklistedname.name} was successfully updated."
                           redirect_to blacklistednames_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "Blacklisted name #{@blacklistedname.name} was successfully removed."
                        @blacklistedname.destroy
                        redirect_to blacklistednames_path
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
