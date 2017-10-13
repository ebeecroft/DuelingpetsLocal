module DonorsHelper

   private
      def optional
         value = params[:donationbox_id]
         return value
      end

      def indexCommons
         logged_in = current_user
         if(logged_in)
            if(optional)
               boxFound = Donationbox.find_by_id(optional)
               if(boxFound)
                  allDonations = boxFound.donors.order("created_on desc")
                  @donationbox = boxFound
               else
                  render "start/crazybat"
               end
            else
               if(logged_in.admin)
                  allDonations = Donor.order("created_on desc")
               else
                  redirect_to root_path
               end
            end
            @donors = Kaminari.paginate_array(allDonations).page(params[:page]).per(10)
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
               if(current_user && current_user.admin)
                  indexCommons
               else
                  allMode = Maintenancemode.find_by_id(1)
                  userMode = Maintenancemode.find_by_id(5)
                  if(allMode.maintenance_on || userMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/users/maintenance"
                     end
                  else
                     indexCommons
                  end
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               userMode = Maintenancemode.find_by_id(5)
               if(allMode.maintenance_on || userMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/users/maintenance"
                  end
               else
                  boxFound = Donationbox.find_by_id(optional)
                  if(boxFound)
                     if(current_user && current_user.id != boxFound.user_id)
                        if(type == "new")
                           newDonor = boxFound.donors.new
                           @donationbox = boxFound
                           @donor = newDonor
                        end
                        if(type == "create")
                           newDonor = boxFound.donors.new(params[:donor])
                           newDonor.created_on = currentTime
                           newDonor.user_id = current_user.id
                           @donor = newDonor
                           if(@donor.valid?)
                              if(@donor.amount > 0)
                                 pouch = Pouch.find_by_user_id(current_user.id)
                                 if(pouch.amount > 0 && @donor.amount <= pouch.amount)
                                    if(@donor.save)
                                       #Increment the donation box
                                       points = boxFound.progress + @donor.amount
                                       boxFound.progress = points
                                       if(boxFound.progress > boxFound.goal && !boxFound.hit_goal)
                                          boxFound.hit_goal = true
                                          netPoints = points - boxFound.goal
                                          UserMailer.goal_reached(boxFound, points, netPoints).deliver
                                       end

                                       #Decrement the user's pouch
                                       pouch.amount -= @donor.amount
                                       @pouch = pouch
                                       @pouch.save

                                       @donationbox = boxFound
                                       if(@donationbox.valid?)
                                          flash[:success] = "#{@donor.user.vname}'s donation was successfully created."
                                          @donationbox.save
                                          redirect_to user_path(@donor.donationbox.user)
                                       else
                                          #Use puts for debuging and inspect
                                          #All data is stored in errors field
                                          flash[:error] = "This case should never happen"
                                          @donationbox = boxFound
                                          render "new"
                                       end
                                    else
                                       @donationbox = boxFound
                                       render "new"
                                    end
                                 else
                                    @donationbox = boxFound
                                    flash[:error] = "You do not have that many points to donate"
                                    render "new"
                                 end
                              else
                                 @donationbox = boxFound
                                 flash[:error] = "You need to donate at least 1 point"
                                 render "new"
                              end
                           else
                              @donationbox = boxFound
                              flash[:error] = "You entered a negative number"
                              render "new"
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            elsif(type == "destroy")
               donorFound = Donor.find_by_id(params[:id])
               if(donorFound)
                  if(current_user && current_user.admin)
                     @donor = donorFound
                     flash[:success] = "#{@donor.user.vname}'s donation was successfully removed."
                     @donor.destroy
                     redirect_to donors_path
                  else
                     redirect_to root_path
                  end
               else
                  render "start/crazybat"
               end
            end
         end
      end
end
