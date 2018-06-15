module ReferralsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  allReferrals = Referral.order("created_on desc")
                  @referrals = Kaminari.paginate_array(allReferrals).page(params[:page]).per(10)
               else
                  redirect_to root_path
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
                  logged_in = current_user
                  if(logged_in && logged_in.referral.nil?)
                     newReferral = Referral.new
                     errorFlag = 0
                     if(type == "create")
                        userFound = User.find_by_vname(params[:session][:vname].downcase)
                        if(userFound)
                           newReferral = Referral.new(params[:referral])
                           newReferral.created_on = currentTime
                           newReferral.from_user_id = userFound.id
                           newReferral.user_id = logged_in.id
                        else
                           errorFlag = 1
                        end
                     end
                     @user = User.find_by_vname(logged_in.vname)
                     @referral = newReferral
                     if(type == "create")
                        if(errorFlag != 1 && logged_in.id != newReferral.from_user_id)
                           @referral.save
                           pouchFound = Pouch.find_by_user_id(@referral.from_user_id)
                           pointsForReferral = 600
                           pouchFound.amount += pointsForReferral
                           @pouch = pouchFound
                           @pouch.save
                           UserMailer.user_referral(@referral, pointsForReferral).deliver
                           flash[:success] = "#{@referral.to_user.vname} referral was successfully created."
                           redirect_to user_path(@referral.to_user)
                        else
                           flash.now[:error] = "Referral Name was invalid!"
                           render "new"
                        end
                     end
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "edit" || type == "update")
               referralFound = Referral.find_by_id(params[:id])
               if(referralFound)
                  logged_in = current_user
                  if(logged_in && logged_in.admin)
                     @referral = referralFound
                     if(type == "update")
                        userFound = User.find_by_vname(params[:session][:vname].downcase)
                        if(userFound && userFound.id != referralFound.user_id)
                           referralFound.from_user_id = userFound.id
                           @referral = referralFound
                           if(@referral.update_attributes(params[:referral]))
                              flash[:success] = "#{@referral.to_user.vname} referral was successfully updated"
                           end
                           redirect_to referrals_path
                        else
                           flash.now[:error] = "Referral Name was invalid"   
                           render "edit"
                        end
                     end
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
