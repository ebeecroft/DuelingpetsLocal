module StartHelper

   private
      def getSunk(timeframe)
         points = blogsSunk(timeframe)
         return points
      end

      def getSourced(timeframe)
         movies = moviesSourced(timeframe)
         blogs = blogsSourced(timeframe)
         colors = colorschemesSourced(timeframe)
         replies = repliesSourced(timeframe)
         referrals = referralsSourced(timeframe)
         points = colors + blogs + replies + referrals + movies
         return points
      end

      def getTransfers(timeframe)
         points = transferredPoints(timeframe)
      end

      def transferredPoints(timeframe)
         allDonors = Donor.all
         nonBot = allDonors.select{|donor| donor.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|donor| (currentTime - donor.created_on) <= 1.day}
         week = nonBot.select{|donor| (currentTime - donor.created_on) <= 1.week}
         month = nonBot.select{|donor| (currentTime - donor.created_on) <= 1.month}
         year = nonBot.select{|donor| (currentTime - donor.created_on) <= 1.year}
         threeyear = nonBot.select{|donor| (currentTime - donor.created_on) <= 3.years}
         firstDonor = Donor.first
         bacot = nonBot.select{|donor| (currentTime - donor.created_on) > (firstDonor.created_on.year - 1.year)}

         #Point values
         dayTransfers = day.sum{|donor| donor.amount}
         weekTransfers = week.sum{|donor| donor.amount} - dayTransfers
         monthTransfers = month.sum{|donor| donor.amount} - weekTransfers - dayTransfers
         yearTransfers = year.sum{|donor| donor.amount} - monthTransfers - weekTransfers - dayTransfers
         dreiJahreTransfers = threeyear.sum{|donor| donor.amount} - yearTransfers - monthTransfers - weekTransfers - dayTransfers
         bacotTransfers = bacot.sum{|donor| donor.amount} - dreiJahreTransfers - yearTransfers - monthTransfers - weekTransfers - dayTransfers
         donorTransfers = nonBot.sum{|donor| donor.amount}

         points = dayTransfers
         if(timeframe == "Week")
            points = weekTransfers
         elsif(timeframe == "Month")
            points = monthTransfers
         elsif(timeframe == "Year")
            points = yearTransfers
         elsif(timeframe == "Threeyears")
            points = dreiJahreTransfers
         elsif(timeframe == "BaconOfTomato")
            points = bacotTransfers
         elsif(timeframe == "All")
            points = donorTransfers
         end
         return points
      end

      def referrals(type)
         allReferrals = Referral.all
         value = 0
         if(type == "Discovery")
            discovery = allReferrals.select{|referral| referral.referred_by.vname == "none"}
            value = discovery.count
         else
            userReferral = allReferrals.select{|referral| referral.referred_by.vname != "none"}
            value = userReferral.count
         end
         return value
      end

      def referralsSourced(timeframe)
         allReferrals = Referral.all
         nonBot = allReferrals.select{|referral| referral.referred_by.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|referral| (currentTime - referral.created_on) <= 1.day}
         week = nonBot.select{|referral| (currentTime - referral.created_on) <= 1.week}
         month = nonBot.select{|referral| (currentTime - referral.created_on) <= 1.month}
         year = nonBot.select{|referral| (currentTime - referral.created_on) <= 1.year}
         threeyear = nonBot.select{|referral| (currentTime - referral.created_on) <= 3.years}
         firstReferral = Referral.first
         bacot = nonBot.select{|referral| (currentTime - referral.created_on) > (firstReferral.created_on.year - 1.year)}

         #Point values
         daySources = day.count * 600
         weekSources = week.count * 600 - daySources
         monthSources = month.count * 600 - weekSources - daySources
         yearSources = year.count * 600 - monthSources - weekSources - daySources
         dreiJahreSources = threeyear.count * 600 - yearSources - monthSources - weekSources - daySources
         bacotSources = bacot.count * 600 - dreiJahreSources - yearSources - monthSources - weekSources - daySources
         referralSources = nonBot.count * 600

         points = daySources
         if(timeframe == "Week")
            points = weekSources
         elsif(timeframe == "Month")
            points = monthSources
         elsif(timeframe == "Year")
            points = yearSources
         elsif(timeframe == "Threeyears")
            points = dreiJahreSources
         elsif(timeframe == "BaconOfTomato")
            points = bacotSources
         elsif(timeframe == "All")
            points = referralSources
         end
         return points
      end

      def colorschemes
         allColors = Colorscheme.all
         nonBot = allColors.select{|colorscheme| colorscheme.user.pouch.privilege != "Bot"}
         value = nonBot.count
         return value
      end

      def colorschemesSourced(timeframe)
         allColors = Colorscheme.all
         nonBot = allColors.select{|colorscheme| colorscheme.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) <= 1.day}
         week = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) <= 1.week}
         month = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) <= 1.month}
         year = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) <= 1.year}
         threeyear = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) <= 3.years}
         firstColor = Colorscheme.first
         bacot = nonBot.select{|colorscheme| (currentTime - colorscheme.created_on) > (firstColor.created_on.year - 1.year)}

         #Point values
         daySources = day.count * 12
         weekSources = week.count * 12 - daySources
         monthSources = month.count * 12 - weekSources - daySources
         yearSources = year.count * 12 - monthSources - weekSources - daySources
         dreiJahreSources = threeyear.count * 12 - yearSources - monthSources - weekSources - daySources
         bacotSources = bacot.count * 12 - dreiJahreSources - yearSources - monthSources - weekSources - daySources
         colorSources = nonBot.count * 12

         points = daySources
         if(timeframe == "Week")
            points = weekSources
         elsif(timeframe == "Month")
            points = monthSources
         elsif(timeframe == "Year")
            points = yearSources
         elsif(timeframe == "Threeyears")
            points = dreiJahreSources
         elsif(timeframe == "BaconOfTomato")
            points = bacotSources
         elsif(timeframe == "All")
            points = colorSources
         end
         return points
      end

      def channelTime(timeframe)
         allChannels = Channel.all
         firstChannel = Channel.first
         nonBot = allChannels.select{|channel| channel.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|channel| (currentTime - channel.created_on) <= 1.day}
         week = nonBot.select{|channel| (currentTime - channel.created_on) <= 1.week}
         month = nonBot.select{|channel| (currentTime - channel.created_on) <= 1.month}
         year = nonBot.select{|channel| (currentTime - channel.created_on) <= 1.year}
         threeyear = nonBot.select{|channel| (currentTime - channel.created_on) <= 3.years}
         bacot = nonBot.select{|channel| (currentTime - channel.created_on) > (firstChannel.created_on.year - 1.year)}

         #Count values
         dayCount = day.count
         weekCount = week.count - dayCount
         monthCount = month.count - weekCount - dayCount
         yearCount = year.count - monthCount - weekCount - dayCount
         dreiJahreCount = threeyear.count - yearCount - monthCount - weekCount - dayCount
         bacotCount = bacot.count - dreiJahreCount - yearCount - monthCount - weekCount - dayCount

         value = dayCount
         if(timeframe == "Week")
            value = weekCount
         elsif(timeframe == "Month")
            value = monthCount
         elsif(timeframe == "Year")
            value = yearCount
         elsif(timeframe == "Threeyears")
            value = dreiJahreCount
         elsif(timeframe == "BaconOfTomato")
            value = bacotCount
         elsif(timeframe == "All")
            value = nonBot.count
         end
         return value
      end

      def mainplaylistTime(timeframe)
         allMainplaylists = Mainplaylist.all
         firstPlaylist = Mainplaylist.first
         nonBot = allMainplaylists.select{|mainplaylist| mainplaylist.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) <= 1.day}
         week = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) <= 1.week}
         month = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) <= 1.month}
         year = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) <= 1.year}
         threeyear = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) <= 3.years}
         bacot = nonBot.select{|mainplaylist| (currentTime - mainplaylist.created_on) > (firstPlaylist.created_on.year - 1.year)}

         #Count values
         dayCount = day.count
         weekCount = week.count - dayCount
         monthCount = month.count - weekCount - dayCount
         yearCount = year.count - monthCount - weekCount - dayCount
         dreiJahreCount = threeyear.count - yearCount - monthCount - weekCount - dayCount
         bacotCount = bacot.count - dreiJahreCount - yearCount - monthCount - weekCount - dayCount

         value = dayCount
         if(timeframe == "Week")
            value = weekCount
         elsif(timeframe == "Month")
            value = monthCount
         elsif(timeframe == "Year")
            value = yearCount
         elsif(timeframe == "Threeyears")
            value = dreiJahreCount
         elsif(timeframe == "BaconOfTomato")
            value = bacotCount
         elsif(timeframe == "All")
            value = nonBot.count
         end
         return value
      end

      def subplaylistTime(timeframe)
         allSubplaylists = Subplaylist.all
         firstPlaylist = Subplaylist.first
         nonBot = allSubplaylists.select{|subplaylist| subplaylist.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) <= 1.day}
         week = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) <= 1.week}
         month = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) <= 1.month}
         year = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) <= 1.year}
         threeyear = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) <= 3.years}
         bacot = nonBot.select{|subplaylist| (currentTime - subplaylist.created_on) > (firstPlaylist.created_on.year - 1.year)}

         #Count values
         dayCount = day.count
         weekCount = week.count - dayCount
         monthCount = month.count - weekCount - dayCount
         yearCount = year.count - monthCount - weekCount - dayCount
         dreiJahreCount = threeyear.count - yearCount - monthCount - weekCount - dayCount
         bacotCount = bacot.count - dreiJahreCount - yearCount - monthCount - weekCount - dayCount

         value = dayCount
         if(timeframe == "Week")
            value = weekCount
         elsif(timeframe == "Month")
            value = monthCount
         elsif(timeframe == "Year")
            value = yearCount
         elsif(timeframe == "Threeyears")
            value = dreiJahreCount
         elsif(timeframe == "BaconOfTomato")
            value = bacotCount
         elsif(timeframe == "All")
            value = nonBot.count
         end
         return value
      end

      def movies
         allMovies = Movie.all
         reviewedMovies = allMovies.select{|movie| movie.reviewed}
         nonBot = reviewedMovies.select{|movie| movie.user.pouch.privilege != "Bot"}
         value = nonBot.count
         return value
      end

      def moviesSourced(timeframe)
         allMovies = Movie.all
         reviewedMovies = allMovies.select{|movie| movie.reviewed}
         nonBot = reviewedMovies.select{|movie| movie.user.pouch.privilege != "Bot"}
         points = 0
         if(reviewedMovies)
            #Time values
            day = nonBot.select{|movie| (currentTime - movie.created_on) <= 1.day}
            week = nonBot.select{|movie| (currentTime - movie.created_on) <= 1.week}
            month = nonBot.select{|movie| (currentTime - movie.created_on) <= 1.month}
            year = nonBot.select{|movie| (currentTime - movie.created_on) <= 1.year}
            threeyear = nonBot.select{|movie| (currentTime - movie.created_on) <= 3.years}
            firstMovie = Movie.first
            bacot = nonBot.select{|movie| (currentTime - movie.created_on) > (firstMovie.created_on.year - 1.year)}

            #Point values
            daySources = day.count * 200
            weekSources = week.count * 200 - daySources
            monthSources = month.count * 200 - weekSources - daySources
            yearSources = year.count * 200 - monthSources - weekSources - daySources
            dreiJahreSources = threeyear.count * 200 - yearSources - monthSources - weekSources - daySources
            bacotSources = bacot.count * 200 - dreiJahreSources - yearSources - monthSources - weekSources - daySources
            movieSources = nonBot.count * 200

            points = daySources
            if(timeframe == "Week")
               points = weekSources
            elsif(timeframe == "Month")
               points = monthSources
            elsif(timeframe == "Year")
               points = yearSources
            elsif(timeframe == "Threeyears")
               points = dreiJahreSources
            elsif(timeframe == "BaconOfTomato")
               points = bacotSources
            elsif(timeframe == "All")
               points = movieSources
            end
         end
         return points
      end

      def replies
         allReplies = Reply.all
         value = allReplies.count
         return value
      end

      def repliesSourced(timeframe)
         allReplies = Reply.all
         uniqueReplies = allReplies.select{|reply| reply.user.id != reply.blog.user.id}
         nonBot = uniqueReplies.select{|reply| reply.user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|reply| (currentTime - reply.created_on) <= 1.day}
         week = nonBot.select{|reply| (currentTime - reply.created_on) <= 1.week}
         month = nonBot.select{|reply| (currentTime - reply.created_on) <= 1.month}
         year = nonBot.select{|reply| (currentTime - reply.created_on) <= 1.year}
         threeyear = nonBot.select{|reply| (currentTime - reply.created_on) <= 3.years}
         firstReply = Reply.first
         bacot = nonBot.select{|reply| (currentTime - reply.created_on) > (firstReply.created_on.year - 1.year)}

         #Point values
         daySources = day.count * 5
         weekSources = week.count * 5 - daySources
         monthSources = month.count * 5 - weekSources - daySources
         yearSources = year.count * 5 - monthSources - weekSources - daySources
         dreiJahreSources = threeyear.count * 5 - yearSources - monthSources - weekSources - daySources
         bacotSources = bacot.count * 5 - dreiJahreSources - yearSources - monthSources - weekSources - daySources
         replySources = nonBot.count * 5

         points = daySources
         if(timeframe == "Week")
            points = weekSources
         elsif(timeframe == "Month")
            points = monthSources
         elsif(timeframe == "Year")
            points = yearSources
         elsif(timeframe == "Threeyears")
            points = dreiJahreSources
         elsif(timeframe == "BaconOfTomato")
            points = bacotSources
         elsif(timeframe == "All")
            points = replySources
         end
         return points
      end

      def blogsSourced(timeframe)
         allBlogs = Blog.all
         regularBlogs = allBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s == "" && blog.largeimage1.to_s == "" && blog.largeimage2.to_s == "" && blog.largeimage3.to_s == "" && blog.smallimage1.to_s == "" && blog.smallimage2.to_s == "" && blog.smallimage3.to_s == "" && blog.smallimage4.to_s == "" && blog.smallimage5.to_s == ""}
         nonBot = regularBlogs.select{|blog| blog.user.pouch.privilege != "Bot"}
         points = 0
         if(regularBlogs)
            #Time values
            day = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.day}
            week = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.week}
            month = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.month}
            year = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.year}
            threeyear = nonBot.select{|blog| (currentTime - blog.created_on) <= 3.years}
            firstBlog = Blog.first
            bacot = nonBot.select{|blog| (currentTime - blog.created_on) > (firstBlog.created_on.year - 1.year)}

            #Daily values
            mascots = day.select{|blog| blog.admascot.to_s != ""}
            textblogs = day.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            daySources = sources

            #Week values
            mascots = week.select{|blog| blog.admascot.to_s != ""}
            textblogs = week.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            weekSources = sources - daySources

            #Month values
            mascots = month.select{|blog| blog.admascot.to_s != ""}
            textblogs = month.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            monthSources = sources - weekSources - daySources

            #Year values
            mascots = year.select{|blog| blog.admascot.to_s != ""}
            textblogs = year.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            yearSources = sources - monthSources - weekSources - daySources

            #3 Years values
            mascots = threeyear.select{|blog| blog.admascot.to_s != ""}
            textblogs = threeyear.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            dreiJahreSources = sources - yearSources - monthSources - weekSources - daySources

            #Bacon of Tomato values
            mascots = bacot.select{|blog| blog.admascot.to_s != ""}
            textblogs = bacot.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            bacotSources = sources - dreiJahreSources - yearSources - monthSources - weekSources - daySources

            #Blog sources
            mascots = nonBot.select{|blog| blog.admascot.to_s != ""}
            textblogs = nonBot.select{|blog| blog.admascot.to_s == ""}
            sources = (textblogs.count * 30) + (mascots.count * 90)
            blogSources = sources

            points = daySources
            if(timeframe == "Week")
               points = weekSources
            elsif(timeframe == "Month")
               points = monthSources
            elsif(timeframe == "Year")
               points = yearSources
            elsif(timeframe == "Threeyears")
               points = dreiJahreSources
            elsif(timeframe == "BaconOfTomato")
               points = bacotSources
            elsif(timeframe == "All")
               points = blogSources
            end
         end
         return points
      end

      def blogsSunk(timeframe)
         allBlogs = Blog.all
         adBlogs = allBlogs.select{|blog| blog.reviewed && blog.adbanner.to_s != "" || blog.largeimage1.to_s != "" || blog.largeimage2.to_s != "" || blog.largeimage3.to_s != "" || blog.smallimage1.to_s != "" || blog.smallimage2.to_s != "" || blog.smallimage3.to_s != "" || blog.smallimage4.to_s != "" || blog.smallimage5.to_s != ""}
         nonBot = adBlogs.select{|blog| blog.user.pouch.privilege != "Bot"}
         points = 0
         if(adBlogs)
            #Time values
            day = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.day}
            week = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.week}
            month = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.month}
            year = nonBot.select{|blog| (currentTime - blog.created_on) <= 1.year}
            threeyear = nonBot.select{|blog| (currentTime - blog.created_on) <= 3.years}
            firstBlog = Blog.first
            bacot = nonBot.select{|blog| (currentTime - blog.created_on) > (firstBlog.created_on.year - 1.year)}

            #Daily values
            banners = day.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = day.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = day.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = day.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = day.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = day.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = day.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = day.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = day.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            daySinks = sinks

            #Week values
            banners = week.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = week.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = week.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = week.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = week.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = week.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = week.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = week.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = week.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            weekSinks = sinks - daySinks

            #Month values
            banners = month.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = month.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = month.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = month.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = month.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = month.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = month.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = month.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = month.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            monthSinks = sinks - weekSinks - daySinks

            #Year values
            banners = year.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = year.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = year.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = year.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = year.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = year.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = year.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = year.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = year.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            yearSinks = sinks - monthSinks - weekSinks - daySinks

            #3 Year values
            banners = threeyear.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = threeyear.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = threeyear.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = threeyear.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = threeyear.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = threeyear.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = threeyear.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = threeyear.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = threeyear.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            dreiJahreSinks = sinks - yearSinks - monthSinks - weekSinks - daySinks

            #Bacon of Tomato values
            banners = bacot.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = bacot.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = bacot.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = bacot.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = bacot.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = bacot.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = bacot.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = bacot.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = bacot.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            bacotSinks = sinks - dreiJahreSinks - yearSinks - monthSinks - weekSinks - daySinks

            #All Ad values
            banners = nonBot.select{|blog| blog.adbanner.to_s != ""}
            largeimage1 = nonBot.select{|blog| blog.largeimage1.to_s != ""}
            largeimage2 = nonBot.select{|blog| blog.largeimage2.to_s != ""}
            largeimage3 = nonBot.select{|blog| blog.largeimage3.to_s != ""}
            smallimage1 = nonBot.select{|blog| blog.smallimage1.to_s != ""}
            smallimage2 = nonBot.select{|blog| blog.smallimage2.to_s != ""}
            smallimage3 = nonBot.select{|blog| blog.smallimage3.to_s != ""}
            smallimage4 = nonBot.select{|blog| blog.smallimage4.to_s != ""}
            smallimage5 = nonBot.select{|blog| blog.smallimage5.to_s != ""}
            sinks = (banners.count * 36000) + (largeimage1.count * 8000) + (largeimage2.count * 8000) + (largeimage3.count * 8000) + (smallimage1.count * 2000) + (smallimage2.count * 2000) + (smallimage3.count * 2000) + (smallimage4.count * 2000) + (smallimage5.count * 2000)
            adSinks = sinks

            points = daySinks
            if(timeframe == "Week")
               points = weekSinks
            elsif(timeframe == "Month")
               points = monthSinks
            elsif(timeframe == "Year")
               points = yearSinks
            elsif(timeframe == "Threeyears")
               points = dreiJahreSinks
            elsif(timeframe == "BaconOfTomato")
               points = bacotSinks
            elsif(timeframe == "All")
               points = adSinks
            end
         end
         return points
      end

      def blogs
         allBlogs = Blog.all
         reviewedBlogs = allBlogs.select{|blog| blog.reviewed}
         nonBot = reviewedBlogs.select{|blog| blog.user.pouch.privilege != "Bot"}
         value = nonBot.count
         return value
      end

      def getContest
         allPouches = Pouch.all
         pouchesNotZero = allPouches.select{|pouch| pouch.activated && pouch.amount > 0}
         botUsers = pouchesNotZero.select{|pouch| pouch.user.pouch.privilege == "Bot"}
         points = botUsers.sum{|pouch| pouch.amount}
         return points
      end

      def getEconomy
         allPouches = Pouch.all
         pouchesNotZero = allPouches.select{|pouch| pouch.activated && pouch.amount > 0}
         nonBot = pouchesNotZero.select{|pouch| pouch.user.pouch.privilege != "Bot"}
         points = nonBot.sum{|pouch| pouch.amount}
         return points
      end

      def getAvgIncome
         points = Pouch.average(:amount, :conditions => ['activated = ? && amount > ? && privilege != ?', true, 0, "Bot"])
         if(points == nil)
            points = 0
         end
         return points
      end

      def getUserStatus(status)
         allPouches = Pouch.all

         #Status value
         onlineUsers = allPouches.select{|pouch| (pouch.activated && pouch.privilege != "Bot") && (!pouch.signed_out_at && pouch.last_visited && (currentTime - pouch.last_visited) < 30.minutes)}
         inactiveUsers = allPouches.select{|pouch| (pouch.activated && pouch.privilege != "Bot") && (!pouch.signed_out_at && pouch.last_visited && (currentTime - pouch.last_visited) >= 30.minutes)}
         offlineUsers = allPouches.select{|pouch| (pouch.activated && pouch.privilege != "Bot") && pouch.signed_in_at && pouch.signed_out_at}
         bots = allPouches.select{|pouch| !pouch.activated}

         #Count values
         onlineCount = onlineUsers.count
         inactiveCount = inactiveUsers.count
         offlineCount = offlineUsers.count
         botCount = bots.count

         value = onlineCount
         if(status == "Inactive")
            value = inactiveCount
         elsif(status == "Offline")
            value = offlineCount
         elsif(status == "Bots")
            value = botCount
         end
         return value
      end

      def getGroups(name)
         allUsers = User.all
         currentDate = Date.today
         nonBot = allUsers.select{|user| user.pouch.privilege != "Bot"}

         #Group values
         babbity = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 7.years}
         rabbit = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 13.years}
         blueland = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 19.years}
         dragon = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 25.years}
         silverwing = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 31.years}
         harahpin = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) < 37.years}
         rings = nonBot.select{|user| (currentDate.to_time - user.birthday.to_time) >= 37.years}

         #Count values
         rabbitCount = rabbit.count - babbity.count
         bluelandCount = blueland.count - rabbitCount - babbity.count
         dragonCount = dragon.count - bluelandCount - rabbitCount - babbity.count
         silverwingCount = silverwing.count - dragonCount - bluelandCount - rabbitCount - babbity.count
         harahpinCount = harahpin.count - silverwingCount - dragonCount - bluelandCount - rabbitCount - babbity.count
         ringsCount = rings.count
 
         value = 0
         if(name == "Rabbit")
            value = rabbitCount
         elsif(name == "Blueland")
            value = bluelandCount
         elsif(name == "Dragon")
            value = dragonCount
         elsif(name == "Silverwing")
            value = silverwingCount
         elsif(name == "Harahpin")
            value = harahpinCount
         elsif(name == "Rings")
            value = ringsCount
         end
         return value
      end

      def getSignups(timeframe)
         allUsers = User.all
         firstUser = User.first
         nonBot = allUsers.select{|user| user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|user| (currentTime - user.joined_on) <= 1.day}
         week = nonBot.select{|user| (currentTime - user.joined_on) <= 1.week}
         month = nonBot.select{|user| (currentTime - user.joined_on) <= 1.month}
         year = nonBot.select{|user| (currentTime - user.joined_on) <= 1.year}
         threeyear = nonBot.select{|user| (currentTime - user.joined_on) <= 3.years}
         bacot = nonBot.select{|user| (currentTime - user.joined_on) > (firstUser.joined_on.year - 1.year)}

         #Count values
         dayCount = day.count
         weekCount = week.count - dayCount
         monthCount = month.count - weekCount - dayCount
         yearCount = year.count - monthCount - weekCount - dayCount
         dreiJahreCount = threeyear.count - yearCount - monthCount - weekCount - dayCount
         bacotCount = bacot.count - dreiJahreCount - yearCount - monthCount - weekCount - dayCount

         signups = dayCount
         if(timeframe == "Week")
            signups = weekCount
         elsif(timeframe == "Month")
            signups = monthCount
         elsif(timeframe == "Year")
            signups = yearCount
         elsif(timeframe == "Threeyears")
            signups = dreiJahreCount
         elsif(timeframe == "BaconOfTomato")
            signups = bacotCount
         elsif(timeframe == "All")
            signups = nonBot.count
         end
         return signups
      end

      def shoutTime(timeframe)
         allShouts = Shout.all
         firstShout = Shout.first
         nonBot = allShouts.select{|shout| shout.from_user.pouch.privilege != "Bot"}

         #Time values
         day = nonBot.select{|shout| (currentTime - shout.created_on) <= 1.day}
         week = nonBot.select{|shout| (currentTime - shout.created_on) <= 1.week}
         month = nonBot.select{|shout| (currentTime - shout.created_on) <= 1.month}
         year = nonBot.select{|shout| (currentTime - shout.created_on) <= 1.year}
         threeyear = nonBot.select{|shout| (currentTime - shout.created_on) <= 3.years}
         bacot = nonBot.select{|shout| (currentTime - shout.created_on) > (firstShout.created_on.year - 1.year)}

         #Count values
         dayCount = day.count
         weekCount = week.count - dayCount
         monthCount = month.count - weekCount - dayCount
         yearCount = year.count - monthCount - weekCount - dayCount
         dreiJahreCount = threeyear.count - yearCount - monthCount - weekCount - dayCount
         bacotCount = bacot.count - dreiJahreCount - yearCount - monthCount - weekCount - dayCount

         value = dayCount
         if(timeframe == "Week")
            value = weekCount
         elsif(timeframe == "Month")
            value = monthCount
         elsif(timeframe == "Year")
            value = yearCount
         elsif(timeframe == "Threeyears")
            value = dreiJahreCount
         elsif(timeframe == "BaconOfTomato")
            value = bacotCount
         elsif(timeframe == "All")
            value = nonBot.count
         end
         return value
      end

      def activeCommons
         allUsers = Pouch.all
         activeUsers = allUsers.select{|pouch| pouch.activated && !pouch.signed_out_at && pouch.last_visited && (currentTime - pouch.last_visited) < 30.minutes}
         @pouches = Kaminari.paginate_array(activeUsers).page(params[:page]).per(250)
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "home")
               if(!current_user || !current_user.admin)
                  allMode = Maintenancemode.find_by_id(1)
                  if(allMode.maintenance_on)
                     #the render section
                     render "/start/maintenance"
                  end
               end
            elsif(type == "stats")
               if(!current_user || !current_user.admin)
                  allMode = Maintenancemode.find_by_id(1)
                  if(allMode.maintenance_on)
                     #the render section
                     render "/start/maintenance"
                  end
               end
            elsif(type == "contact")
               #This field is left empty
            elsif(type == "sitemap")
               if(!current_user || !current_user.admin)
                  allMode = Maintenancemode.find_by_id(1)
                  if(allMode.maintenance_on)
                     #the render section
                     render "/start/maintenance"
                  end
               end
            elsif(type == "active")
               if(current_user)
                  if(!current_user.admin)
                     allMode = Maintenancemode.find_by_id(1)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        activeCommons
                     end
                  else
                     activeCommons
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "revertcolor")
               if(current_user)
                  userFound = Userinfo.find_by_user_id(current_user.id)
                  userFound.colorscheme_id = 1
                  @userinfo = userFound
                  @userinfo.save
                  flash[:success] = "Default color is now being used."
                  redirect_to root_path
               else
                  redirect_to root_path
               end
            end
         end
      end
end
