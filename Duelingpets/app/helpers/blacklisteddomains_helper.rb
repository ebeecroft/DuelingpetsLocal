module BlacklisteddomainsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user && current_user.admin)
               if(type == "index")
                  allDomains = Blacklisteddomain.order("created_on desc")
                  @blacklisteddomains = Kaminari.paginate_array(allDomains).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newDomain = Blacklisteddomain.new
                  if(type == "create")
                     newDomain = Blacklisteddomain.new(params[:blacklisteddomain])
                     newDomain.created_on = currentTime
                  end
                  @blacklisteddomain = newDomain
                  if(type == "create")
                     if(@blacklisteddomain.save)
                        flash[:success] = "The domain #{@blacklisteddomain.name} has been added to the blacklist!"
                        redirect_to blacklisteddomains_path
                     else
                        render "new"
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  domainFound = Blacklisteddomain.find_by_name(params[:id])
                  if(domainFound)
                     @blacklisteddomain = domainFound
                     if(type == "update")
                        if(@blacklisteddomain.update_attributes(params[:blacklisteddomain]))
                           flash[:success] = "The domain #{@blacklisteddomain.name} was successfully updated."
                           redirect_to blacklisteddomains_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "Blacklisted domain #{@blacklisteddomain.name} was successfully removed."
                        @blacklisteddomain.destroy
                        redirect_to blacklisteddomains_path
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
