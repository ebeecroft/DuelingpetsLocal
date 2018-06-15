module BlogsHelper

   private
      def getBlogVisitors(timeframe, blog)
         #Time values
         allVisits = blog.blogvisits.order("created_on desc")
         pastTwenty = allVisits.select{|visit| (currentTime - visit.created_on) <= 20.minutes}
         pastFourty = allVisits.select{|visit| (currentTime - visit.created_on) <= 40.minutes}
         pasthour = allVisits.select{|visit| (currentTime - visit.created_on) <= 1.hour}
         past2hours = allVisits.select{|visit| (currentTime - visit.created_on) <= 2.hours}
         past3hours = allVisits.select{|visit| (currentTime - visit.created_on) <= 3.hours}

         #Count values
         past20MinsCount = pastTwenty.count
         past40MinsCount = pastFourty.count - past20MinsCount
         pasthourCount = pasthour.count - past40MinsCount - past20MinsCount
         past2hoursCount = past2hours.count - pasthourCount - past40MinsCount - past20MinsCount
         past3hoursCount =  past3hours.count - past2hoursCount - pasthourCount - past40MinsCount - past20MinsCount

         #value = past20Count
         if(timeframe == "past20mins")
            value = past20MinsCount
         elsif(timeframe == "past40mins")
            value = past40MinsCount
         elsif(timeframe == "pasthour")
            value = pasthourCount
         elsif(timeframe == "past2hours")
            value = past2hoursCount
         elsif(timeframe == "past3hours")
            value = past3hoursCount
         end
         return value
      end

      def retrieveBlogStar(blog)
         allStars = blog.blogstars.order("created_on desc")
         starFound = allStars.select{|star| star.user_id == current_user.id}
         return starFound.count
      end

      def saveCommons(blog, user)
         @blog = blog
         @user = user
         if(@blog.save)
            ContentMailer.blog_review(@blog).deliver
            flash[:success] = "#{@blog.user.vname} blog #{@blog.title} was successfully created."
            redirect_to user_blog_path(@user, @blog)
         else
            render "new"
         end
      end

      def optional
         value = params[:user_id]
         return value
      end

      def cleanupOldVisits
         allVisits = Blogvisit.order("created_on desc")
         oldVisits = allVisits.select{|visit| currentTime - visit.created_on > 3.hours}
         if(oldVisits.count > 0)
            oldVisits.each do |visit|
               @blogvisit = visit
               @blogvisit.destroy
            end
         end
      end

      def saveVisit(blogFound, visitor)
         allVisits = blogFound.blogvisits.order("created_on desc")
         blogVisited = allVisits.select{|visit| ((currentTime - visit.created_on) < 10.mins) && (visit.user_id == visitor.id)}
         if(blogVisited.count == 0)
            #Add visitor to list
            newVisit = blogFound.blogvisits.new(params[:blogvisit])
            newVisit.user_id = visitor.id
            newVisit.created_on = currentTime
            @blogvisit = newVisit
            @blogvisit.save
         end
      end

      def visitTimer(type, blogFound)
         #Determines if we have visitors to our page
         if(type == "show")
            visitor = current_user
            if(visitor)
               userPouch = Pouch.find_by_user_id(visitor.id)
               userPouch.last_visited = currentTime
               @pouch = userPouch
               @pouch.save

               #Checks to see that the visitor and
               #our user are not the same
               if(visitor.id != blogFound.user_id && !visitor.admin)
                  timer = Pagetimer.find_by_name("Blog")
                  if(timer.expiretime - currentTime <= 0)
                     value = duration.min.from_now.utc
                     timer.expiretime = value
                     @pagetimer = pagetimer
                     @pagetimer.save
                     saveVisit(blogFound, visitor)
                  else
                     saveVisit(blogFound, visitor)
                  end
               end
            end
         end
      end

      def showCommons(type)
         blogFound = Blog.find_by_id(params[:id])
         if(blogFound)
            if(blogFound.reviewed || current_user && ((blogFound.user_id == current_user.id) || current_user.admin))
               visitTimer(type, blogFound)
               cleanupOldVisits
               @blog = blogFound
               blogReplies = @blog.replies.order("created_on desc")
               @replies = Kaminari.paginate_array(blogReplies).page(params[:page]).per(6)
               stars = @blog.blogstars.count
               @stars = stars
               if(type == "destroy")
                  logged_in = current_user
                  if(logged_in && ((logged_in.id == blogFound.user_id) || logged_in.admin))
                     @blog.destroy
                     flash[:success] = "#{@blog.title} was successfully removed."
                     if(logged_in.admin)
                        redirect_to blogs_list_path
                     else
                        redirect_to user_blogs_path(blogFound.user)
                     end
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

      def editCommons(type)
         blogFound = Blog.find_by_id(params[:id])
         if(blogFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == blogFound.user_id) || logged_in.admin))
               @blog = blogFound
               @user = User.find_by_vname(blogFound.user.vname)
               if(type == "update")
                  if(@blog.update_attributes(params[:blog]))
                     flash[:success] = "Blog #{@blog.title} was successfully updated."
                     redirect_to user_blog_path(@blog.user, @blog)
                  else
                     render "edit"
                  end
               end
            else
               redirect_to root_path
            end
         else
            render "start/crazybat"
         end
      end

      def indexCommons
         if(optional)
            userFound = User.find_by_vname(optional)
            if(userFound)
               userBlogs = userFound.blogs.order("created_on desc")
               blogsReviewed = userBlogs.select{|blog| blog.reviewed || (current_user && blog.user_id == current_user.id)}
               @user = userFound
            else
               render "start/crazybat"
            end
         else
            allBlogs = Blog.order("created_on desc")
            blogsReviewed = allBlogs.select{|blog| blog.reviewed || (current_user && blog.user_id == current_user.id)}
         end
         @blogs = Kaminari.paginate_array(blogsReviewed).page(params[:page]).per(10)
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index") #Guests
               allMode = Maintenancemode.find_by_id(1)
               blogMode = Maintenancemode.find_by_id(6)
               if(allMode.maintenance_on || blogMode.maintenance_on)
                  if(current_user && current_user.admin)
                     indexCommons
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/blogs/maintenance"
                     end
                  end
               else
                  indexCommons
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               blogMode = Maintenancemode.find_by_id(6)
               if(allMode.maintenance_on || blogMode.maintenance_on)
                  if(allMode.maintenance_on)
                     render "/start/maintenance"
                  else
                     render "/blogs/maintenance"
                  end
               else
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newBlog = logged_in.blogs.new
                        if(type == "create")
                           newBlog = logged_in.blogs.new(params[:blog])
                           newBlog.created_on = currentTime
                        end
                        @blog = newBlog
                        @user = userFound
                        if(type == "create")
                           adsNotOn = (@blog.adbanner.to_s == "" && @blog.largeimage1.to_s == "" && @blog.largeimage2.to_s == "" && @blog.largeimage3.to_s == "" && @blog.smallimage1.to_s == "" && @blog.smallimage2.to_s == "" && @blog.smallimage3.to_s == "" && @blog.smallimage4.to_s == "" && @blog.smallimage5.to_s == "")
                           if(adsNotOn)
                              saveCommons(@blog, @user)
                           else
                              #Keeps track of the price
                              pricetag = 0

                              #Banner Pricing(36000)
                              if(@blog.adbanner.to_s != "")
                                 pricetag -= 36000
                              end

                              #Large Image Pricing(24000)
                              if(@blog.largeimage1.to_s != "")
                                 pricetag -= 8000
                              end

                              if(@blog.largeimage2.to_s != "")
                                 pricetag -= 8000
                              end

                              if(@blog.largeimage3.to_s != "")
                                 pricetag -= 8000
                              end

                              #Small Image Pricing(10000)
                              if(@blog.smallimage1.to_s != "")
                                 pricetag -= 2000
                              end

                              if(@blog.smallimage2.to_s != "")
                                 pricetag -= 2000
                              end

                              if(@blog.smallimage3.to_s != "")
                                 pricetag -= 2000
                              end

                              if(@blog.smallimage4.to_s != "")
                                 pricetag -= 2000
                              end

                              if(@blog.smallimage5.to_s != "")
                                 pricetag -= 2000
                              end
                              pouchValue = @user.pouch.amount + pricetag
                              if(pouchValue < 0)
                                 flash[:error] = "You have insufficient points to pay for all these ads!"
                                 render "new"
                              else
                                 saveCommons(@blog, @user)
                              end
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     redirect_to root_path
                  end
               end
            elsif(type == "edit" || type == "update")
               if(current_user && current_user.admin)
                  editCommons(type)
               else
                  allMode = Maintenancemode.find_by_id(1)
                  blogMode = Maintenancemode.find_by_id(6)
                  if(allMode.maintenance_on || blogMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/blogs/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            elsif(type == "show" || type == "destroy")
               allMode = Maintenancemode.find_by_id(1)
               blogMode = Maintenancemode.find_by_id(6)
               if(allMode.maintenance_on || blogMode.maintenance_on)
                  if(current_user && current_user.admin)
                     showCommons(type)
                  else
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/blogs/maintenance"
                     end
                  end
               else
                  showCommons(type)
               end
            elsif(type == "list" || type == "review")
               logged_in = current_user
               if(logged_in)
                  allBlogs = Blog.order("created_on desc")
                  if(type == "review")
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                        blogsToReview = allBlogs.select{|blog| !blog.reviewed}
                        @blogs = Kaminari.paginate_array(blogsToReview).page(params[:page]).per(4)
                     else
                        redirect_to root_path
                     end
                  else
                     if(logged_in.admin)
                        @blogs = allBlogs.page(params[:page]).per(4)
                     else
                        redirect_to root_path
                     end
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "approve" || type == "deny")
               logged_in = current_user
               if(logged_in)
                  blogFound = Blog.find_by_id(params[:blog_id])
                  if(blogFound)
                     value = ""
                     pouchFound = Pouch.find_by_user_id(logged_in.id)
                     if(logged_in.admin || ((pouchFound.privilege == "Keymaster") || (pouchFound.privilege == "Reviewer")))
                        if(type == "approve")
                           blogFound.reviewed = true
                           pouch = Pouch.find_by_user_id(blogFound.user_id)
                           adsNotOn = (blogFound.adbanner.to_s == "" && blogFound.largeimage1.to_s == "" && blogFound.largeimage2.to_s == "" && blogFound.largeimage3.to_s == "" && blogFound.smallimage1.to_s == "" && blogFound.smallimage2.to_s == "" && blogFound.smallimage3.to_s == "" && blogFound.smallimage4.to_s == "" && blogFound.smallimage5.to_s == "")
                           pointsForBlog = 60
                           if(adsNotOn)
                              if(blogFound.admascot.to_s != "")
                                 pointsForBlog = 100
                              end
                           else
                              #Keeps track of the price
                              pricetag = 0

                              #Banner Pricing(36000)
                              if(blogFound.adbanner.to_s != "")
                                 pricetag -= 36000
                              end

                              #Large Image Pricing(24000)
                              if(blogFound.largeimage1.to_s != "")
                                 pricetag -= 8000
                              end

                              if(blogFound.largeimage2.to_s != "")
                                 pricetag -= 8000
                              end

                              if(blogFound.largeimage3.to_s != "")
                                 pricetag -= 8000
                              end

                              #Small Image Pricing(10000)
                              if(blogFound.smallimage1.to_s != "")
                                 pricetag -= 2000
                              end

                              if(blogFound.smallimage2.to_s != "")
                                 pricetag -= 2000
                              end

                              if(blogFound.smallimage3.to_s != "")
                                 pricetag -= 2000
                              end

                              if(blogFound.smallimage4.to_s != "")
                                 pricetag -= 2000
                              end

                              if(blogFound.smallimage5.to_s != "")
                                 pricetag -= 2000
                              end
                              pointsForBlog = pricetag
                           end
                           pouch.amount += pointsForBlog
                           @pouch = pouch
                           @pouch.save
                           @blog = blogFound
                           @blog.save
                           ContentMailer.blog_approved(@blog, pointsForBlog).deliver
                           allWatches = Watch.all
                           watchers = allWatches.select{|watch| ((((watch.watchtype.name == "Blogs" || watch.watchtype.name == "Blogarts") || (watch.watchtype.name == "Blogsounds" || watch.watchtype.name == "Blogmovies")) || (watch.watchtype.name == "Forumblogs" || watch.watchtype.name == "All"))) && watch.from_user.id != @blog.user_id}
                           if(watchers.count > 0)
                              watchers.each do |watch|
                                 UserMailer.new_blog(@blog, watch).deliver
                              end
                           end
                           value = "#{@blog.user.vname}'s blog #{@blog.title} was approved."
                        else
                           @blog = blogFound
                           ContentMailer.blog_denied(@blog).deliver
                           value = "#{@blog.user.vname}'s blog #{@blog.title} was denied."
                        end
                        flash[:success] = value
                        redirect_to blogs_review_path
                     else
                        redirect_to root_path
                     end
                  else
                     render "start/crazybat"
                  end
               else
                  redirect_to root_path
               end
            end
         end
      end
end
