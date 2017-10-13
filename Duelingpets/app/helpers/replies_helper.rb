module RepliesHelper

   private
      def editCommons(type)
         replyFound = Reply.find_by_id(params[:id])
         if(replyFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == replyFound.user_id) || logged_in.admin))
               @reply = replyFound
               blogFound = Blog.find_by_id(@reply.blog_id)
               @blog = blogFound
               if(type == "update")
                  if(@reply.update_attributes(params[:reply]))
                     flash[:success] = "#{@reply.user.vname}'s reply was successfully updated."
                     redirect_to user_blog_path(@blog.user, @reply.blog)
                  else
                     render "edit"
                  end
               end
            elsif(logged_in && (((logged_in.id == replyFound.blog.user_id) || (logged_in.id == replyFound.user_id)) || logged_in.admin))
               if(type == "destroy")
                  flash[:success] = "#{@reply.user.vname}'s reply was successfully removed."
                  @reply.destroy
                  if(logged_in.admin)
                     replies_path
                  else
                     redirect_to user_blog_path(@blog.user, @blog)
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
                  allReplies = Reply.order("created_on desc").page(params[:page]).per(10)
                  @replies = allReplies
               else
                  redirect_to root_path
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
                  blogFound = Blog.find_by_id(params[:blog_id])
                  if(blogFound)
                     logged_in = current_user
                     if(logged_in)
                        newReply = blogFound.replies.new
                        if(type == "create")
                           newReply = blogFound.replies.new(params[:reply])
                           newReply.created_on = currentTime
                           newReply.user_id = logged_in.id
                        end
                        @reply = newReply
                        @blog = blogFound
                        if(type == "create")
                           if(@reply.save)
                              if(@reply.user_id != @blog.user_id)
                                 pouch = Pouch.find_by_user_id(@reply.blog.user_id)
                                 pointsForReply = 5
                                 pouch.amount += pointsForReply
                                 @pouch = pouch
                                 @pouch.save
                              end
                              flash[:success] = "#{@reply.user.vname}'s reply was successfully created."
                              redirect_to user_blog_path(@blog.user, @reply.blog)
                           else
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
            elsif(type == "edit" || type == "update" || type == "destroy")
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
            end
         end
      end
end
