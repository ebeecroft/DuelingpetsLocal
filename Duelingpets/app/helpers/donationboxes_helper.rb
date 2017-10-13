module DonationboxesHelper

   private
      def editCommons(type)
         boxFound = Donationbox.find_by_id(params[:id])
         if(boxFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == boxFound.user_id) || logged_in.admin))
               if(type == "update")
                  boxFound.initialized_on = currentTime
               end
               @donationbox = boxFound
               @user = User.find_by_vname(boxFound.user.vname)
               if(type == "update")
                  if(logged_in.admin || !boxFound.turn_on)
                     if(@donationbox.update_attributes(params[:donationbox]))
                        flash[:success] = "#{@user.vname}'s donationbox was successfully updated."
                        redirect_to user_path(@user)
                     else
                        render "edit"
                     end
                  else
                     redirect_to root_path
                  end
               elsif(type == "retrieve")
                  if(logged_in.id == boxFound.user_id && boxFound.hit_goal)
                     pouch = Pouch.find_by_user_id(@user.id)
                     points = @donationbox.progress

                     #Calculate the tax
                     results = `/home/eric/Projects/Local/Websites/Resources/Code/dbox/calz #{points}`
                     string_array = results.split(",")
                     pointsTax, taxRate = string_array.map{|str| str.to_f}

                     #Send the points to the user's pouch
                     netPoints = @donationbox.progress - pointsTax
                     pouch.amount += netPoints
                     @pouch = pouch
                     @pouch.save
                     @donationbox.progress = 0
                     @donationbox.goal = 0
                     @donationbox.hit_goal = false
                     @donationbox.turn_on = false
                     @donationbox.save
                     redirect_to user_path(@user)
                  else
                     redirect_to root_path
                  end
               elsif(type == "refund")
                  if(logged_in.admin || !boxFound.hit_goal)
                     #Retrieve all donations
                     allDonors = Donor.all
                     boxDonors = allDonors.select{|donor| donor.donationbox_id == boxFound.id}
                     activeDonors = boxDonors.select{|donor| donor.created_on > boxFound.initialized_on}

                     #Gives back the original users donations
                     activeDonors.each do |donor|
                        donor.user.pouch.amount += donor.amount
                        boxFound.progress -= donor.amount
                        @donationbox = boxFound
                        @donationbox.save
                        @pouch = donor.user.pouch
                        @pouch.save
                        @donor = donor
                        @donor.destroy
                     end
                     boxFound.turn_on = false
                     boxFound.goal = 0
                     boxFound.progress = 0
                     if(boxFound.hit_goal)
                        boxFound.hit_goal = false
                     end
                     @donationbox = boxFound
                     @donationbox.save
                     redirect_to user_path(@donationbox.user)
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allBoxes = Donationbox.order("initialized_on desc")
                  @donationboxes = Kaminari.paginate_array(allBoxes).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "edit" || type == "update" || type == "retrieve" || type == "refund")
               if(current_user && current_user.admin)
                  editCommons(type)
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
                     editCommons(type)
                  end
               end
            end
         end
      end
end
