module ChannelvisitsHelper

   private
      def destroyCommons(type)
         logged_in = current_user
         if(logged_in && logged_in.admin)
            if(type == "destroy")
               visitFound = Channelvisit.find_by_id(params[:id])
               if(visitFound)
                  @channelvisit = visitFound
                  flash[:success] = "Channelvisit was successfully removed."
                  @channelvisit.destroy
                  redirect_to channelvisits_visitlist
               else
                  render "start/crazybat"
               end
            else
               allVisits = Channelvisit.order("created_on desc")
               @channelvisits = Kaminari.paginate_array(allVisits).page(params[:page]).per(10)
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
               channelMode = Maintenancemode.find_by_id(7)
               if(allMode.maintenance_on || channelMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/channels/maintenance"
                  end
               else
                  channelFound = Channel.find_by_name(params[:channel_id])
                  if(channelFound)
                     channelVisits = channelFound.channelvisits.order("created_on desc")
                     @channel = channelFound
                     @channelvisits = Kaminari.paginate_array(channelVisits).page(params[:page]).per(10)
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
