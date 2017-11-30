module SuggestionsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index" || type == "destroy" || type == "applied")
               logged_in = current_user
               if(logged_in && logged_in.admin)
                  if(type == "index")
                     allSuggestions = Suggestion.order("created_on desc")
                     @suggestions = Kaminari.paginate_array(allSuggestions).page(params[:page]).per(20)
                  elsif(type == "destroy")
                     suggestionFound = Suggestion.find_by_title(params[:id])
                     if(suggestionFound)
                        @suggestion = suggestionFound
                        flash[:success] = "#{@suggestion.title} was successfully removed."
                        @suggestion.destroy
                        redirect_to suggestions_path
                     else
                        render "start/crazybat"
                     end
                  elsif(type == "applied")
                     suggestionFound = Suggestion.find_by_title(params[:suggestion_id])
                     if(suggestionFound)
                        suggestionFound.applied = true
                        @suggestion = suggestionFound
                        if(@suggestion.save)
                           pouch = Pouch.find_by_user_id(suggestionFound.user_id)
                           pointsForSuggestion = 40
                           ContentMailer.suggestion_applied(@suggestion, pointsForSuggestion).deliver
                           pouch.amount += pointsForSuggestion
                           @pouch = pouch
                           @pouch.save
                           flash[:success] = "Suggestion was applied"
                        end
                        redirect_to suggestions_path
                     else
                        render "start/crazybat"
                     end
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "new" || type == "create")
               allMode = Maintenancemode.find_by_id(1)
               if(allMode.maintenance_on)
                  render "/start/maintenance"
               else
                  logged_in = current_user
                  userFound = User.find_by_vname(params[:user_id])
                  if(logged_in && userFound)
                     if(logged_in.id == userFound.id)
                        newSuggestion = logged_in.suggestions.new
                        if(type == "create")
                           newSuggestion = logged_in.suggestions.new(params[:suggestion])
                           newSuggestion.created_on = currentTime
                        end
                        @user = userFound
                        @suggestion = newSuggestion
                        if(type == "create")
                           if(@suggestion.save)
                              ContentMailer.suggestion_review(@suggestion).deliver
                              flash[:success] = "Suggestion #{@suggestion.title} was successfully created."
                              redirect_to root_path
                           else
                              render "new"
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
end
