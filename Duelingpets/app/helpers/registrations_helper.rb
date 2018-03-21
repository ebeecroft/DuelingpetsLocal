module RegistrationsHelper

   private
      def validateRegistration(registration)
         #Blacklist variables
         names = Blacklistedname.all
         domains = Blacklisteddomain.all
         name, domain = registration.email.split("@")
         matchType = "None"
         valid = true

         #Checks to see if there is any matches
         firstnameMatch = names.select{|blacklistname| blacklistname.name.downcase == registration.first_name.downcase}
         lastnameMatch = names.select{|blacklistname| blacklistname.name.downcase == registration.last_name.downcase}
         loginMatch = names.select{|blacklistname| blacklistname.name.downcase == registration.login_id.downcase}
         vnameMatch = names.select{|blacklistname| blacklistname.name.downcase == registration.vname.downcase}
         domainMatch = domains.select{|blacklistdomain| blacklistdomain.name.downcase == domain.downcase && blacklistdomain.domain_only}

         #Determines if this is a domain match or an email match
         if(domainMatch.count != 0)
            matchType = "Domain"
         else
            nameMatch = names.select{|blacklistname| blacklistname.name.downcase == name.downcase}
            domainMatch = domains.select{|blacklistdomain| blacklistdomain.name.downcase == domain.downcase && !blacklistdomain.domain_only}
            if(nameMatch.count != 0 && domainMatch.count != 0)
               matchType = "Email"
            end
         end

         #Displays the error messages for invalid registrations
         if(firstnameMatch.count != 0)
            flash.now[:firstnameerror] = "The firstname #{registration.first_name} is blacklisted!"
            valid = false
         end
         if(lastnameMatch.count != 0)
            flash.now[:lastnameerror] = "The lastname #{registration.last_name} is blacklisted!"
            valid = false
         end
         if(loginMatch.count != 0)
            flash.now[:loginerror] = "The login name #{registration.login_id} is blacklisted!"
            valid = false
         end
         if(vnameMatch.count != 0)
            flash.now[:vnameerror] = "The virtual name #{registration.vname} is blacklisted!"
            valid = false
         end
         if(matchType == "Domain")
            flash.now[:error] = "The domain #{domain} is blacklisted!"
            valid = false
         elsif(matchType == "Email")
            flash.now[:error] = "The email #{registration.email} is blacklisted!"
            valid = false
         end
         return valid
      end

      def gateStatus
         gate = Maintenancemode.find_by_id(2)
         value = gate.maintenance_on
         return value
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               logged_in = current_user
               if(logged_in && logged_in.admin || logged_in.pouch.privilege == "Keymaster")
                  allRegistrations = Registration.order("joined_on desc").page(params[:page]).per(10)
                  @registrations = allRegistrations
               else
                  redirect_to root_path
               end
            elsif(type == "register" || type == "verify")
               allMode = Maintenancemode.find_by_id(1)
               gateMode = Maintenancemode.find_by_id(4)
               if(allMode.maintenance_on || gateMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/registrations/maintenance"
                  end
               else
                  if(type == "verify")
                     color_value = params[:session][:color].downcase
                     if(color_value)
                        if(color_value == "pink" || color_value == "red" || color_value == "blue" || color_value == "green" || color_value == "cyan" || color_value == "magenta" || color_value == "orange" || color_value == "brown" || color_value == "yellow")
                           @registration = Registration.new
                           render "register2"
                        else
                           flash[:error] = "Invalid color value"
                           redirect_to root_path
                        end
                     else
                        flash[:error] = "Invalid color value"
                        redirect_to root_path
                     end
                  end
               end
            elsif(type == "register2" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               gateMode = Maintenancemode.find_by_id(4)
               if(allMode.maintenance_on || gateMode.maintenance_on)
                  if(allMode.maintenance_on)
                     #the render section
                     render "/start/maintenance"
                  else
                     render "/registrations/maintenance"
                  end
               else
                  newRegistration = Registration.new
                  if(type == "create")
                     newRegistration = Registration.new(params[:registration])
                     newRegistration.joined_on = currentTime
                  end
                  @registration = newRegistration
                  if(type == "create")
                     if(validateRegistration(newRegistration))
                        if(@registration.save)
                           flash[:success] = "Thank you for registration we will review your account over 
                           the next three days to see if it is legitimate."
                           UserMailer.registration_review(@registration).deliver
                           redirect_to root_path
                        else
                           render "register2"
                        end
                     else
                        @registration = newRegistration
                        render "register2"
                     end
                  end
               end
            elsif(type == "approve" || type == "deny")
               logged_in = current_user
               if(logged_in)
                  registrationFound = Registration.find_by_id(params[:id])
                  if(registrationFound)
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || pouchFound.privilege == "Keymaster")
                        @registration = registrationFound
                        if(type == "approve")
                           #Might consider adding some points in later
                           #Creates the user
                           newUser = User.new(params[:user])
                           newUser.joined_on = currentTime
                           newUser.first_name = registrationFound.first_name
                           newUser.last_name = registrationFound.last_name
                           newUser.email = registrationFound.email
                           newUser.vname = registrationFound.vname
                           newUser.login_id = registrationFound.login_id
                           newUser.country = registrationFound.country
                           newUser.country_timezone = registrationFound.country_timezone
                           newUser.birthday = registrationFound.birthday
                           initialPassword = SecureRandom.urlsafe_base64
                           newUser.password = initialPassword
                           newUser.password_confirmation = initialPassword
                           newUser.admin = registrationFound.admin
                           @user = newUser
                           if(@user.save)
                              #Creates the user info
                              newInfo = Userinfo.new(params[:userinfo])
                              newInfo.browser = "ogg-browser"
                              newInfo.vbrowser = "ogv-browser"
                              newInfo.info = "This is a test"
                              newInfo.user_id = @user.id
                              newInfo.colorscheme_id = 1
                              @userinfo = newInfo
                              @userinfo.save
                              #Creates the users pouch
                              starterPoints = -4000
                              newPouch = Pouch.new(params[:pouch])
                              newPouch.user_id = @user.id
                              newPouch.remember_token = SecureRandom.urlsafe_base64
                              newPouch.amount = starterPoints
                              timeout = 1.day.from_now.utc
                              newPouch.expiretime = timeout
                              @pouch = newPouch
                              @pouch.save
                              @password = initialPassword
                              UserMailer.login_info(@user, @password).deliver
                              flash[:success] = "Registration was converted to a user."
                              #Creates the donationbox
                              newBox = Donationbox.new(params[:donationbox])
                              newBox.user_id = @user.id
                              newBox.initialized_on = currentTime
                              newBox.description = "Describe your donation"
                              @donationbox = newBox
                              @donationbox.save
                              #Inform users of new user
                              blogger = User.find_by_vname("blogger")
                              newBlog = blogger.blogs.new(params[:blog])
                              newBlog.title = "Let-us-welcome-#{@user.vname}-our-newest-member!"
                              newBlog.description = "Welcome #{@user.vname} to the Duelingpets virtual pet site. I hope you enjoy your stay here and make many new friends. The older members of this site will teach you the ropes of the system. #{@user.vname} joined our site on #{@user.joined_on.strftime("%B-%d-%Y")}. So please give a round of applause to our newest member."
                              newBlog.created_on = currentTime
                              newBlog.reviewed = true
                              @blog = newBlog
                              @blog.save
                              #Reward blogger for new member
                              bloggerPouch = Pouch.find_by_user_id(blogger.id)
                              blogPoints = 30
                              bloggerPouch.amount += blogPoints
                              @pouch2 = bloggerPouch
                              @pouch2.save
                              @registration.destroy
                           else
                              flash[:error] = "Registration failed."
                           end
                        else
                           UserMailer.bot_registration(@registration).deliver
                           flash[:success] = "Registration was found to be a bot and was deleted."
                           @registration.destroy
                        end
                        redirect_to registrations_path
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "gate")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  gateStatus = Maintenancemode.find_by_id(4)
                  if(gateStatus.maintenance_on)
                     gateStatus.maintenance_on = false
                  else
                     gateStatus.maintenance_on = true
                  end
                  @maintenancemode = gateStatus
                  @maintenancemode.save
                  redirect_to registrations_path
               else
                  redirect_to root_path
               end
            end
         end
      end
end
