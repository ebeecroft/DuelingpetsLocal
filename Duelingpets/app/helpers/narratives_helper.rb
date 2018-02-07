module NarrativesHelper

   private
      def forumGroupAccess(forumgroup, logged_in)
         value = false
         if(forumgroup.name == "RabbitOnly" && getBookGroups(logged_in) == 1)
            value = true
         elsif(forumgroup.name == "BluelandOnly" && getBookGroups(logged_in) == 2)
            value = true
         elsif(forumgroup.name == "DragonOnly" && getBookGroups(logged_in) == 3)
            value = true
         elsif(forumgroup.name == "Rabbit" && getBookGroups(logged_in) >= 1)
            value = true
         elsif(forumgroup.name == "Blueland" && getBookGroups(logged_in) >= 2)
            value = true
         elsif(forumgroup.name == "Dragon" && getBookGroups(logged_in) >= 3)
            value = true
         elsif(forumgroup.name == "Silverwing" && getBookGroups(logged_in) >= 4)
            value = true
         elsif(forumgroup.name == "Harahpin" && getBookGroups(logged_in) >= 5)
            value = true
         elsif(forumgroup.name == "LOTR" && getBookGroups(logged_in) == 6)
            value = true
         end
         return value
      end

      def stylizedText(textString, categoryType)
         styleString = textString

         #Emphasizes the content for description fields
         if(categoryType == "Bold")
            styleString = textString.gsub(/\[[Bb][Oo][Ll][Dd]\]([\w\s.?!,$'"*:;-]+)\[\/[Bb][Oo][Ll][Dd]\]/){"<strong>"+$1+"</strong>"}
         elsif(categoryType == "Italic")
            styleString = textString.gsub(/\[[Ii][Tt][Aa][Ll][Ii][Cc]\]([\w\s.?!,$'"*:;-]+)\[\/[Ii][Tt][Aa][Ll][Ii][Cc]\]/){"<em>"+$1+"</em>"}
         elsif(categoryType == "Underline")
            #Remember to replace u tag with div tag
            styleString = textString.gsub(/\[[Uu][Nn][Dd][Ee][Rr][Ll][Ii][Nn][Ee]\]([\w\s.?!,$'"*:;-]+)\[\/[Uu][Nn][Dd][Ee][Rr][Ll][Ii][Nn][Ee]\]/){"<u>"+$1+"</u>"}
         elsif(categoryType == "All")
            styleString = textString.gsub(/\[[Bb][Oo][Ll][Dd]\]([\w\s.?!,$'"*:;-]+)\[\/[Bb][Oo][Ll][Dd]\]/){"<strong>"+$1+"</strong>"}
            styleString = styleString.gsub(/\[[Ii][Tt][Aa][Ll][Ii][Cc]\]([\w\s.?!,$'"*:;-]+)\[\/[Ii][Tt][Aa][Ll][Ii][Cc]\]/){"<em>"+$1+"</em>"}
            styleString = styleString.gsub(/\[[Uu][Nn][Dd][Ee][Rr][Ll][Ii][Nn][Ee]\]([\w\s.?!,$'"*:;-]+)\[\/[Uu][Nn][Dd][Ee][Rr][Ll][Ii][Nn][Ee]\]/){"<u>"+$1+"</u>"}
         end

         return styleString
      end

      def pageFormating(textString, categoryType)
         pageString = textString

         #Handles how the page is formated
         if(categoryType == "Pagebreak")
            pageString = textString.gsub(/\n/, '<br/>')
         elsif(categoryType == "Strike")
            pageString = textString.gsub(/\[[Ss][Tt][Rr][Ii][Kk][Ee]\]([\w\s.?!,$'"*:;-]+)\[\/[Ss][Tt][Rr][Ii][Kk][Ee]\]/){"<del>"+$1+"</del>"}
         elsif(categoryType == "Link")
            pageString = textString.gsub(/\[[Ll][Ii][Nn][Kk]\]([\w\s\/:.-]+)\[[Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Nn][Aa][Mm][Ee]\]\[\/[Ll][Ii][Nn][Kk]\]/){"<a href=#{$1}>"+$2+"</a>"}
         elsif(categoryType == "All")
            pageString = textString.gsub(/\n/, '<br/>')
            pageString = pageString.gsub(/\[[Ss][Tt][Rr][Ii][Kk][Ee]\]([\w\s.?!,$'"*:;-]+)\[\/[Ss][Tt][Rr][Ii][Kk][Ee]\]/){"<del>"+$1+"</del>"}
            pageString = pageString.gsub(/\[[Ll][Ii][Nn][Kk]\]([\w\s\/:.-]+)\[[Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Nn][Aa][Mm][Ee]\]\[\/[Ll][Ii][Nn][Kk]\]/){"<a href=#{$1}>"+$2+"</a>"}
         end

         return pageString
      end

      def profileText(textString, categoryType)
         profileString = textString

         #Displays attributes related to the users profile
         if(categoryType == "Profile")
            profileString = textString.gsub(/\[[Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]([\w\s\/:.-]+)\[\/[Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.miniavatar_url(:thumb))}
         elsif(categoryType == "Profilename")
            profileString = textString.gsub(/\[[Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.miniavatar_url(:thumb)) + "#{$1}"}
         elsif(categoryType == "Largeprofile")
            profileString = textString.gsub(/\[[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]([\w\s\/:.-]+)\[\/[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.avatar_url(:thumb))}
         elsif(categoryType == "Largeprofilename")
            profileString = textString.gsub(/\[[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.avatar_url(:thumb)) + "#{$1}"}
         elsif(categoryType == "All")
            profileString = textString.gsub(/\[[Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]([\w\s\/:.-]+)\[\/[Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.miniavatar_url(:thumb))}
            profileString = profileString.gsub(/\[[Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.miniavatar_url(:thumb)) + "#{$1}"}
            profileString = profileString.gsub(/\[[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]([\w\s\/:.-]+)\[\/[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.avatar_url(:thumb))}
            profileString = profileString.gsub(/\[[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]([\w\s\/:.-]+)\[\/[Ll][Aa][Rr][Gg][Ee][Pp][Rr][Oo][Ff][Ii][Ll][Ee][Nn][Aa][Mm][Ee]\]/){image_tag(User.find_by_vname($1).userinfo.avatar_url(:thumb)) + "#{$1}"}
         end

         return profileString
      end

      def codeSection(textString)
         #Useful for sharing c++, or other programming languages
         codeString = textString
         codeString = textString.gsub(/\[[Cc][Oo][Dd][Ee]\]([\w\s@*#%$&|!?,.;:'"{}\[\]^()=+*\/-]+)\[\/[Cc][Oo][Dd][Ee]\]/){"<code>"+$1+"</code>"}
         codeString = codeString.gsub(/\[[Gg][Rr][Ee][Aa][Tt][Ee][Rr]\]/){">"}
         codeString = codeString.gsub(/\[[Ll][Ee][Ss][Ss]\]/){"<"}
         codeString = codeString.gsub(/\*\*\*\*([\w\s@]+)\*\*\*\*/){"<#"+$1+">"}
         return codeString
      end

      def textFormater(formatType, textString, categoryType)
         formatedText = textString

         #Determines the correct format type
         if(formatType == "Stylized")
            formatedText = stylizedText(textString, categoryType)
         elsif(formatType == "Formatting")
            formatedText = pageFormating(textString, categoryType)
         elsif(formatType == "Profiletext")
            formatedText = profileText(textString, categoryType)
         elsif(formatType == "Code")
            formatedText = codeSection(textString)
         elsif(formatType == "Multi")
            formatedText = codeSection(textString)
            formatedText = stylizedText(formatedText, categoryType)
            formatedText = pageFormating(formatedText, categoryType)
            formatedText = profileText(formatedText, categoryType)
         end
         return formatedText
      end

      def editCommons(type)
         narrativeFound = Narrative.find_by_id(params[:id])
         if(narrativeFound)
            logged_in = current_user
            if(logged_in && ((logged_in.id == narrativeFound.user_id) || logged_in.admin))
               allGroups = Forumgroup.all
               allowedGroups = allGroups.select{|forumgroup| forumGroupAccess(forumgroup, logged_in)}
               @group = allowedGroups
               @narrative = narrativeFound
               @subtopic = Subtopic.find_by_id(narrativeFound.subtopic_id)
               if(type == "update")
                  if(@narrative.update_attributes(params[:narrative]))
                     flash[:success] = "Narrative #{@narrative.subtopic.title} was successfully updated."
                     redirect_to maintopic_subtopic_path(@narrative.subtopic.maintopic, @narrative.subtopic)
                  else
                     render "edit"
                  end
               elsif(type == "destroy")
                  flash[:success] = "Narrative #{@narrative.subtopic.title} was successfully removed."
                  @narrative.destroy
                  if(logged_in.admin)
                     redirect_to narratives_path
                  else
                     redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
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
                  allNarratives = Narrative.order("created_on desc")
                  @narratives = Kaminari.paginate_array(allNarratives).page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
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
                     logged_in = current_user
                     if(logged_in && (logged_in.id == subtopicFound.maintopic.topiccontainer.forum.user_id || logged_in.id != subtopicFound.maintopic.topiccontainer.forum.user_id))
                        newNarrative = subtopicFound.narratives.new
                        if(type == "create")
                           newNarrative = subtopicFound.narratives.new(params[:narrative])
                           newNarrative.created_on = currentTime
                           newNarrative.user_id = logged_in.id
                        end
                        allGroups = Forumgroup.all
                        allowedGroups = allGroups.select{|forumgroup| forumGroupAccess(forumgroup, logged_in)}
                        @group = allowedGroups
                        @subtopic = subtopicFound
                        @narrative = newNarrative
                        if(type == "create")
                           if(@narrative.save)
                              pointsForNarrative = 40
                              pouch = Pouch.find_by_user_id(@narrative.user_id)
                              pouch.amount += pointsForNarrative
                              @pouch = pouch
                              @pouch.save
                              ContentMailer.narrative_created(@narrative, pointsForNarrative).deliver
                              flash[:success] = "#{@narrative.subtopic.title} was successfully created."
                              redirect_to maintopic_subtopic_path(@narrative.subtopic.maintopic, @narrative.subtopic)
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
                  forumMode = Maintenancemode.find_by_id(10)
                  if(allMode.maintenance_on || forumMode.maintenance_on)
                     if(allMode.maintenance_on)
                        render "/start/maintenance"
                     else
                        render "/forums/maintenance"
                     end
                  else
                     editCommons(type)
                  end
               end
            end
         end
      end
end
