module CusersHelper

   private
      def getColorAttribute(attribute)
         value = ""
         if(current_user)
            usercolor = Colorscheme.find_by_id(current_user.userinfo.colorscheme_id)
            if(attribute == "Backgroundc")
               value = usercolor.backgroundcolor
            elsif(attribute == "Header")
               value = usercolor.headercolor
            elsif(attribute == "Text")
               value = usercolor.textcolor
            elsif(attribute == "Navigation")
               value = usercolor.navigationcolor
            elsif(attribute == "Navigationlink")
               value = usercolor.navigationlinkcolor
            elsif(attribute == "Onlinestatus")
               value = usercolor.onlinestatuscolor
            elsif(attribute == "Profile")
               value = usercolor.profilecolor
            elsif(attribute == "Error")
               value = usercolor.errorcolor
            elsif(attribute == "Warning")
               value = usercolor.warningcolor
            elsif(attribute == "Notification")
               value = usercolor.notificationcolor
            elsif(attribute == "Success")
               value = usercolor.successcolor
            elsif(attribute == "Sessionc")
               value = usercolor.sessioncolor
            elsif(attribute == "Navigationhoverforc")
               value = usercolor.navigationhovercolor
            elsif(attribute == "Navigationhoverbackgc")
               value = usercolor.navigationhoverbackgcolor
            elsif(attribute == "Profilevisited")
               value = usercolor.profilevisitedcolor
            elsif(attribute == "Profilehovercolor")
               value = usercolor.profilehovercolor
            elsif(attribute == "Profilehoverbackgc")
               value = usercolor.profilehoverbackgcolor
            elsif(attribute == "Navlink")
               value = usercolor.navlinkcolor
            elsif(attribute == "Navlinkhovercolor")
               value = usercolor.navlinkhovercolor
            elsif(attribute == "Navlinkhoverbackgc")
               value = usercolor.navlinkhoverbackgcolor
            elsif(attribute == "Explanationborder")
               value = usercolor.explanationborder
            elsif(attribute == "Explanationbackgc")
               value = usercolor.explanationbackgcolor
            elsif(attribute == "Explanheadercolor")
               value = usercolor.explanheadercolor
            elsif(attribute == "Explanheaderbackgc")
               value = usercolor.explanheaderbackgcolor
            elsif(attribute == "Errorfieldcolor")
               value = usercolor.errorfieldcolor
            end
         else
            default = Colorscheme.find_by_id(1)
            if(attribute == "Backgroundc")
               value = default.backgroundcolor
            elsif(attribute == "Header")
               value = default.headercolor
            elsif(attribute == "Text")
               value = default.textcolor
            elsif(attribute == "Navigation")
               value = default.navigationcolor
            elsif(attribute == "Navigationlink")
               value = default.navigationlinkcolor
            elsif(attribute == "Onlinestatus")
               value = default.onlinestatuscolor
            elsif(attribute == "Profile")
               value = default.profilecolor
            elsif(attribute == "Error")
               value = default.errorcolor
            elsif(attribute == "Warning")
               value = default.warningcolor
            elsif(attribute == "Notification")
               value = default.notificationcolor
            elsif(attribute == "Success")
               value = default.successcolor
            elsif(attribute == "Navigationhoverforc")
               value = default.navigationhovercolor
            elsif(attribute == "Navigationhoverbackgc")
               value = default.navigationhoverbackgcolor
            elsif(attribute == "Profilevisited")
               value = default.profilevisitedcolor
            elsif(attribute == "Profilehovercolor")
               value = default.profilehovercolor
            elsif(attribute == "Profilehoverbackgc")
               value = default.profilehoverbackgcolor
            elsif(attribute == "Navlink")
               value = default.navlinkcolor
            elsif(attribute == "Navlinkhovercolor")
               value = default.navlinkhovercolor
            elsif(attribute == "Navlinkhoverbackgc")
               value = default.navlinkhoverbackgcolor
            end
         end
         return value
      end

      def newestArts
         allArts = Art.order("created_on desc")
         reviewedArts = allArts.select{|art| art.reviewed && ((!current_user && art.bookgroup.name == "Peter Rabbit") || (current_user && (art.bookgroup.id <= getBookGroups(current_user))))}
         arts = reviewedArts.take(3)
         return arts
      end

      def newestMovies
         allMovies = Movie.order("created_on desc")
         reviewedMovies = allMovies.select{|movie| movie.reviewed && ((!current_user && movie.bookgroup.name == "Peter Rabbit") || (current_user && (movie.bookgroup.id <= getBookGroups(current_user))))}
         movies = reviewedMovies.take(3)
         return movies
      end

      def checkMusicFlag
         if(cookies[:music_on].nil?)
            cookies[:music_on] = "On"
         else
            cookies[:music_on]
         end
      end

      def getCrazyBatVideo
         video = ""
         if(current_user)
            if(current_user.userinfo.vbrowser == "ogv-browser")
               video = "/Resources/Video/crazybat/bat.ogv"
            elsif(current_user.userinfo.vbrowser == "mp4-browser")
               video = "/Resources/Video/crazybat/bat.mp4"
            end
         else
            video = "/Resources/Video/crazybat/bat.ogv"
         end
         return video
      end

      def getHomepageMusic
         music = ""
         if(current_user)
            if(current_user.userinfo.browser == "ogg-browser")
               betaMode = Maintenancemode.find_by_id(2)
               grandMode = Maintenancemode.find_by_id(3)
               music = "/Resources/Music/homepage/Theme.ogg"
               if(betaMode.maintenance_on)
                  music = "/Resources/Music/homepage/BetaTheme.ogg"
               elsif(grandMode.maintenance_on)
                  music = "/Resources/Music/homepage/GrandTheme.ogg"
               end
            elsif(current_user.userinfo.browser == "mp3-browser")
               betaMode = Maintenancemode.find_by_id(2)
               grandMode = Maintenancemode.find_by_id(3)
               music = "/Resources/Music/homepage/Theme.mp3"
               if(betaMode.maintenance_on)
                  music = "/Resources/Music/homepage/BetaTheme.mp3"
               elsif(grandMode.maintenance_on)
                  music = "/Resources/Music/homepage/GrandTheme.mp3"
               end
            end
         else
            betaMode = Maintenancemode.find_by_id(2)
            grandMode = Maintenancemode.find_by_id(3)
            music = "/Resources/Music/homepage/Theme.ogg"
            if(betaMode.maintenance_on)
               music = "/Resources/Music/homepage/BetaTheme.ogg"
            elsif(grandMode.maintenance_on)
               music = "/Resources/Music/homepage/GrandTheme.ogg"
            end
         end
         return music
      end

      def getVideo(movie)
         video = ""
         if(current_user)
            if(current_user.userinfo.vbrowser == "ogv-browser")
               video = movie.ogv_url 
            elsif(current_user.userinfo.vbrowser == "mp4-browser")
               video = movie.mp4_url
            end
         else
            video = movie.ogv_url 
         end
         return video
      end

      def getGalleryMusic(gallery)
         music = ""
         if(current_user)
            if(current_user.userinfo.browser == "ogg-browser")
               music = gallery.ogg_url
            elsif(current_user.userinfo.browser == "mp3-browser")
               music = gallery.mp3_url
            end
         else
            music = gallery.ogg_url
         end
      end

      def getUserMusic(user)
         music = ""
         if(current_user)
            if(current_user.userinfo.browser == "ogg-browser")
               music = user.userinfo.ogg_url
            elsif(current_user.userinfo.browser == "mp3-browser")
               music = user.userinfo.mp3_url
            end
         else
            music = user.userinfo.ogg_url
         end
         return music
      end

      def currentTime
         Time.zone.now
      end

      def getClock
         if(current_user)
            militaryTime = false
            clockTime = currentTime.in_time_zone(current_user.country_timezone)
            if(current_user.military_time)
               clockTime.strftime("%H:%M:%S %Z")
            else
               clockTime.strftime("%I:%M:%S %p %Z")
            end
         else
            currentTime.strftime("%I:%M:%S %p %Z")
         end
      end

      def timeExpired #Might change the name to auto logout
         if(current_user)
            userPouch = Pouch.find_by_user_id(current_user.id)
            if(userPouch)
               if(currentTime >= userPouch.expiretime)
                  return true
               else
                  return false
               end
            end
         else
            return false
         end
      end

      def logout_user
         flash[:success] = "Don't worry #{current_user.vname} we will await your return."
         userPouch = Pouch.find_by_user_id(current_user.id)
         userPouch.remember_token = "NULL"
         userPouch.last_visited = nil
         value = currentTime
         if(timeExpired)
            value = userPouch.expiretime
         end
         userPouch.signed_out_at = value
         userPouch.expiretime = nil
         @pouch = userPouch
         @pouch.save
         cookies.delete(:remember_token)
         self.current_user = nil
      end

      def current_user
         userPouch = Pouch.find_by_remember_token(cookies[:remember_token])
         if(userPouch)
            @current_user ||= User.find_by_vname(userPouch.user.vname)
         else
            @current_user
         end
      end

      def current_user=(user)
         @current_user = user
      end
end
