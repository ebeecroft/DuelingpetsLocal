module SubtopicsubscribersHelper

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
                  subtopicFound = Subtopic.find_by_id(params[:subtopic_id])
                  if(subtopicFound)
                     if(type == "index")
                        allSubs = subtopicFound.subtopicsubscribers.order("created_on desc")
                        @subtopicsubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                        @subtopic = subtopicFound
                     else
                        logged_in = current_user
                        if(logged_in && ((logged_in.id == subtopicFound.user_id) || (logged_in.id != subtopicFound.user_id)))
                           allSubs = subtopicFound.subtopicsubscribers.order("created_on desc")
                           subFound = allSubs.select{|subscriber| subscriber.user_id == logged_in.id}
                           if(subFound.count > 0)
                              #Destroy
                              @subtopicsubscriber = Subtopicsubscriber.find_by_id(subFound)
                              @subtopic = subtopicFound
                              flash[:success] = "You have successfully unsubscribed."
                              @subtopicsubscriber.destroy
                              redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
                           else
                              #Check to see that the user isn't subscribed to the topiccontainer
                              topiccontainer = Topiccontainer.find_by_id(subtopicFound.maintopic.topiccontainer_id)
                              allcontainersubs = topiccontainer.containersubscribers.order("created_on desc")
                              containersubFound = allcontainersubs.select{|subscriber| subscriber.user_id == logged_in.id}

                              #Check to see that the user isn't subscribed to the maintopic
                              maintopic = Maintopic.find_by_id(subtopicFound.maintopic_id)
                              allmaintopicsubs = maintopic.maintopicsubscribers.order("created_on desc")
                              maintopicsubFound = allmaintopicsubs.select{|subscriber| subscriber.user_id == logged_in.id}

                              if((containersubFound.count == 0) && (maintopicsubFound.count == 0))
                                 #Create
                                 newSub = subtopicFound.subtopicsubscribers.new(params[:subtopicsubscriber])
                                 newSub.created_on = currentTime
                                 newSub.user_id = logged_in.id
                                 @subtopicsubscriber = newSub
                                 @subtopic = subtopicFound
                                 if(@subtopicsubscriber.save)
                                    if(subtopicFound.maintopic.topiccontainer.forum.user_id != logged_in.id)
                                       #Inform forum owner of new subscriber
                                       pouch = Pouch.find_by_user_id(subtopicFound.maintopic.topiccontainer.forum.user_id)
                                       pointsForSubtopicSub = 5
                                       ContentMailer.forumowner_subtopicsubscriber(@subtopicsubscriber, pointsForSubtopicSub).deliver
                                       pouch.amount += pointsForSubtopicSub
                                       @pouch = pouch
                                       @pouch.save
                                    end
                                    if(subtopicFound.user_id != logged_in.id)
                                       if(subtopicFound.user_id != subtopicFound.maintopic.topiccontainer.forum.user_id)
                                          #Inform subtopic owner of new subscriber
                                          pouch = Pouch.find_by_user_id(subtopicFound.user_id)
                                          pointsForSubtopicSub = 20
                                          ContentMailer.subtopic_subscriber(@subtopicsubscriber, pointsForSubtopicSub).deliver
                                          pouch.amount += pointsForSubtopicSub
                                          @pouch = pouch
                                          @pouch.save
                                       end
                                    end
                                    flash[:success] = "A new subscriber was successfully created."
                                    redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
                                 else
                                    raise "I could not save the data due to an issue problem"
                                 end
                              else
                                 if(containersubFound.count == 0)
                                    flash[:error] = "You are already subscribed to the topiccontainer."
                                 else
                                    flash[:error] = "You are already subscribed to the maintopic."
                                 end
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
                     subFound = Subtopicsubscriber.find_by_id(params[:id])
                     if(subFound)
                        @subtopicsubscriber = subFound
                        @subtopic = Subtopic.find_by_id(subFound.subtopic_id)
                        flash[:success] = "Sub by #{@subtopicsubscriber.user.vname} was successfully removed."
                        @subtopicsubscriber.destroy
                        redirect_to subtopicsubscribers_path
                     else
                        render "start/crazybat"
                     end
                  else
                     allSubs = Subtopicsubscriber.order("created_on desc")
                     @subtopicsubscribers = Kaminari.paginate_array(allSubs).page(params[:page]).per(10)
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
