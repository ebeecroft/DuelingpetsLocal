module ContainersubscribersHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index" || type == "subscribe")
               allMode = Maintenancemode.find_by_id(1)
               forumMode = Maintenancemode.find_by_id(10)
               if(allMode.maintenance_on || forumMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/forums/maintenance"
                  end
               else
                  containerFound = Topiccontainer.find_by_id(params[:topiccontainer_id])
                  if(containerFound)
                     if(type == "index")
                        allSubs = containerFound.containersubscribers.order("created_on desc")
                        @containersubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                        @topiccontainer = containerFound
                     else
                        logged_in = current_user
                        if(logged_in && ((logged_in.id == containerFound.user_id) || (logged_in.id != containerFound.user_id)))
                           allSubs = containerFound.containersubscribers.order("created_on desc")
                           subFound = allSubs.select{|subscriber| subscriber.user_id == logged_in.id}
                           if(subFound.count > 0)
                              #Destroy
                              @containersubscriber = Containersubscriber.find_by_id(subFound)
                              @topiccontainer = containerFound
                              flash[:success] = "You have successfully unsubscribed."
                              @containersubscriber.destroy
                              redirect_to forum_topiccontainer_path(@topiccontainer.forum, @topiccontainer)
                           else
                              #Create
                              newSub = containerFound.containersubscribers.new(params[:containersubscriber])
                              newSub.created_on = currentTime
                              newSub.user_id = logged_in.id
                              @containersubscriber = newSub
                              @topiccontainer = containerFound
                              if(@containersubscriber.save)
                                 if(containerFound.forum.user_id != logged_in.id)
                                    #Inform forum owner of new subscriber
                                    pouch = Pouch.find_by_user_id(containerFound.forum.user_id)
                                    pointsForContainerSub = 60
                                    ContentMailer.forumowner_containersubscriber(@containersubscriber, pointsForContainerSub).deliver
                                    pouch.amount += pointsForContainerSub
                                    @pouch = pouch
                                    @pouch.save
                                 end
                                 if(containerFound.user_id != logged_in.id)
                                    if(containerFound.user_id != containerFound.forum.user_id)
                                       #Inform container owner of new subscriber
                                       pouch = Pouch.find_by_user_id(containerFound.user_id)
                                       pointsForContainerSub = 120
                                       ContentMailer.container_subscriber(@containersubscriber, pointsForContainerSub).deliver
                                       pouch.amount += pointsForContainerSub
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                 end
                                 flash[:success] = "A new subscriber was successfully created."
                                 redirect_to forum_topiccontainer_path(@topiccontainer.forum, @topiccontainer)
                              else
                                 raise "I could not save the data due to an issue problem"
                              end
                           end
                        else
                           redirect_to root_path
                        end
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy" || type == "list")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  if(type == "destroy")
                     subFound = Containersubscriber.find_by_id(params[:id])
                     if(subFound)
                        @containersubscriber = subFound
                        @topiccontainer = Topiccontainer.find_by_id(subFound.topiccontainer_id)
                        flash[:success] = "Sub by #{@containersubscriber.user.vname} was successfully removed."
                        @containersubscriber.destroy
                        redirect_to containersubscribers_path
                     else
                        render "start/crazybat"
                     end                  
                  else
                     allSubs = Containersubscriber.order("created_on desc")
                     @containersubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
