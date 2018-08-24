module MaintopicsubscribersHelper

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
                  maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
                  if(maintopicFound)
                     if(type == "index")
                        allSubs = maintopicFound.maintopicsubscribers.order("created_on desc")
                        @maintopicsubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                        @maintopic = maintopicFound
                     else
                        logged_in = current_user
                        if(logged_in && ((logged_in.id == maintopicFound.user_id) || (logged_in.id != maintopicFound.user_id)))
                           allSubs = maintopicFound.maintopicsubscribers.order("created_on desc")
                           subFound = allSubs.select{|subscriber| subscriber.user_id == logged_in.id}
                           if(subFound.count > 0)
                              #Destroy
                              @maintopicsubscriber = Maintopicsubscriber.find_by_id(subFound)
                              @maintopic = maintopicFound
                              flash[:success] = "You have successfully unsubscribed."
                              @maintopicsubscriber.destroy
                              redirect_to topiccontainer_maintopic_path(@maintopic.topiccontainer, @maintopic)
                           else
                              topiccontainer = Topiccontainer.find_by_id(maintopicFound.topiccontainer_id)
                              allcontainersubs = topiccontainer.containersubscribers.order("created_on desc")
                              containersubFound = allcontainersubs.select{|subscriber| subscriber.user_id == logged_in.id}
                              if(containersubFound.count == 0)
                                 #Create
                                 newSub = maintopicFound.maintopicsubscribers.new(params[:maintopicsubscriber])
                                 newSub.created_on = currentTime
                                 newSub.user_id = logged_in.id
                                 @maintopicsubscriber = newSub
                                 @maintopic = maintopicFound
                                 if(@maintopicsubscriber.save)
                                    if(maintopicFound.topiccontainer.forum.user_id != logged_in.id)
                                       #Inform forum owner of new subscriber
                                       pouch = Pouch.find_by_user_id(maintopicFound.topiccontainer.forum.user_id)
                                       pointsForMaintopicSub = 20
                                       ContentMailer.forumowner_maintopicsubscriber(@maintopicsubscriber, pointsForMaintopicSub).deliver
                                       pouch.amount += pointsForMaintopicSub
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                    if(maintopicFound.user_id != logged_in.id)
                                       if(maintopicFound.user_id != maintopicFound.topiccontainer.forum.user_id)
                                          #Inform maintopic owner of new subscriber
                                          pouch = Pouch.find_by_user_id(maintopicFound.user_id)
                                          pointsForMaintopicSub = 60
                                          ContentMailer.maintopic_subscriber(@maintopicsubscriber, pointsForMaintopicSub).deliver
                                          pouch.amount += pointsForMaintopicSub
                                          @pouch = pouch
                                          @pouch.save
                                       end
                                    end
                                    flash[:success] = "A new subscriber was successfully created."
                                    redirect_to topiccontainer_maintopic_path(@maintopic.topiccontainer, @maintopic)
                                 else
                                    raise "I could not save the data due to an issue problem"
                                 end
                              else
                                 flash[:error] = "You are already subscribed to the topiccontainer."
                                 redirect_to root_path
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
                     subFound = Maintopicsubscriber.find_by_id(params[:id])
                     if(subFound)
                        @maintopicsubscriber = subFound
                        @maintopic = Maintopic.find_by_id(subFound.maintopic_id)
                        flash[:success] = "Sub by #{@maintopicsubscriber.user.vname} was successfully removed."
                        @maintopicsubscriber.destroy
                        redirect_to maintopicsubscribers_path
                     else
                        render "start/crazybat"
                     end
                  else
                     allSubs = Maintopicsubscriber.order("created_on desc")
                     @maintopicsubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
