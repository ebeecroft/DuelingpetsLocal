module SessionsHelper

   private
      def activateMaintenance(pouch)
         pouch.activated = true
         @pouch = pouch
         @pouch.save
         UserMailer.account_info(@pouch.user).deliver
         flash[:success] = "Your account has now been activated!"
         redirect_to login_path
      end

      def recoveryMaintenance(loginUser)
         token = SecureRandom.urlsafe_base64
         loginUser.password = token
         loginUser.password_confirmation = token
         @user = loginUser
         @user.save
         UserMailer.reset_password(@user).deliver
         flash[:success] = "Your password was succesfully sent"
         redirect_to root_path
      end

      def loginMaintenance(loginUser, pouch)
         if(pouch.signed_in_at == nil)
            UserMailer.welcome(loginUser).deliver
            flash[:success] = "Greetings #{loginUser.vname} welcome to Duelingpets"
         else
            flash[:success] = "Welcome back #{loginUser.vname}"
         end
         pouch.remember_token = SecureRandom.urlsafe_base64
         time_limit = 2.days.from_now.utc
         pouch.expiretime = time_limit
         pouch.signed_in_at = currentTime
         pouch.last_visited = nil
         pouch.signed_out_at = nil
         @pouch = pouch
         @pouch.save
         cookie_lifespan = time_limit + 1.month
         cookies[:remember_token] = {:value => pouch.remember_token, :expires => cookie_lifespan}
         self.current_user = loginUser
         redirect_to loginUser
      end

      def sessionCommons(type)
         loginUser = User.find_by_login_id(params[:session][:login_id].downcase)
         if(loginUser)
            pouch = Pouch.find_by_id(loginUser.id)
            if(type == "loginpost")
               password = loginUser.authenticate(params[:session][:password])
               if(pouch.activated && password)
                  allMode = Maintenancemode.find_by_id(1)
                  betaMode = Maintenancemode.find_by_id(2)
                  if(allMode.maintenance_on || betaMode.maintenance_on)
                     if(loginUser.admin)
                        loginMaintenance(loginUser, pouch)
                     else
                        if(allMode.maintenance_on)
                           flash.now[:error] = "Only the admin can login at this time."
                           render "login"
                        else
                           if(((pouch.privilege == "Keymaster" || pouch.privilege == "Reviewer") || (pouch.privilege == "Beta" || pouch.privilege == "Bot")) || loginUser.admin)
                              loginMaintenance(loginUser, pouch)
                           else
                              if(pouch.privilege == "Banned")
                                 flash.now[:error] = "You have been banned from this site."
                              else
                                 flash.now[:error] = "Only members of the beta class and higher can login."
                              end
                              render "login"
                           end
                        end
                     end
                  else
                     if(pouch.privilege != "Banned")
                        loginMaintenance(loginUser, pouch)
                     else
                        flash.now[:error] = "You have been banned from this site."
                        render "login"
                     end
                  end
               else
                  #specific error
                  if(!pouch.activated)
                     flash.now[:error] = "Your account has not been activated yet!"
                  else
                     flash.now[:error] = "Invalid login name/password combination!"
                  end
                  render "login"
               end
            elsif(type == "recoverypost")
               vnameUser = User.find_by_vname(params[:session][:vname])
               if(pouch.activated && vnameUser && vnameUser.id == loginUser.id)
                  allMode = Maintenancemode.find_by_id(1)
                  if(allMode.maintenance_on)
                     if(loginUser.admin)
                        recoveryMaintenance(loginUser)
                     else
                        flash.now[:error] = "Only the admin can recover at this time."
                        redirect_to root_path
                     end
                  else
                     recoveryMaintenance(loginUser)
                  end
               else
                  if(!pouch.activated)
                     flash.now[:error] = "Your account has not been activated yet!"
                     render "recover"
                  else
                     flash[:success] = "Your password was succesfully sent"
                     redirect_to root_path
                  end
               end
            elsif(type == "activatepost")
               token = Pouch.find_by_remember_token(params[:session][:token])
               if(!pouch.activated && token && (token.id == pouch.id) && (currentTime < pouch.expiretime))
                  allMode = Maintenancemode.find_by_id(1)
                  if(allMode.maintenance_on)
                     if(loginUser.admin)
                        activateMaintenance(pouch)
                     else
                        flash.now[:error] = "Only the admin can activate at this time."
                        render "activate"
                     end
                  else
                     activateMaintenance(pouch)
                  end
               else
                  if(pouch.activated)
                     flash.now[:error] = "This account has already been activated!"
                  elsif(currentTime >= pouch.expiretime)
                     flash.now[:error] = "The time limit has expired for activation!"
                  else
                     flash.now[:error] = "Invalid login name/token combination!"
                  end
                  render "activate"
               end
            elsif(type == "resettimepost")
               vnameUser = User.find_by_vname(params[:session][:vname])
               if(!pouch.activated && vnameUser && vnameUser.id == loginUser.id)
                  time_limit = 1.days.from_now.utc
                  pouch.remember_token = SecureRandom.urlsafe_base64
                  pouch.expiretime = time_limit
                  @pouch = pouch
                  @pouch.save
                  UserMailer.reset_time(loginUser).deliver
                  flash[:success] = "Time and token was reset."
                  redirect_to root_path
               else
                  if(pouch.activated)
                     flash.now[:error] = "This account has already been activated!"
                     render "resettime"
                  else
                     flash.now[:error] = "Invalid login name/vname combination!"
                     redirect_to root_path
                  end
               end
            end
         else
            if(type == "loginpost")
               flash.now[:error] = "Invalid login name/password combination!"
               render "login"
            elsif(type == "recoverypost")
               flash[:success] = "Your password was succesfully sent"
               redirect_to root_path
            elsif(type == "activatepost")
               flash.now[:error] = "Invalid login name/token combination!"               
               render "activate"
            elsif(type == "resettimepost")
               flash.now[:error] = "Invalid login name/vname combination!"
               redirect_to root_path
            end
         end
      end

      def mode(type)
         if(type == "loginpost")
            sessionCommons(type)
         elsif(type == "recoverypost")
            sessionCommons(type)
         elsif(type == "activatepost")
            sessionCommons(type)
         elsif(type == "resettimepost")
            sessionCommons(type)
         elsif(type == "destroy")
            logout_user
            redirect_to root_path
         end
      end
end
