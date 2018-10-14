module FaqsHelper

   private
      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(type == "index")
               allFaqs = Faq.order("created_on desc")
               @faqs = Kaminari.paginate_array(allFaqs).page(params[:page]).per(10)
            elsif(type == "new" || type == "create")
               if(current_user && current_user.admin)
                  newFaq = Faq.new
                  if(type == "create")
                     newFaq = Faq.new(params[:faq])
                     newFaq.created_on = currentTime
                  end
                  @faq = newFaq
                  if(type == "create")
                     if(@faq.save)
                        flash[:success] = "Faq #{@faq.title} was successfully created."
                        redirect_to faqs_path
                     else
                        render "new"
                     end
                  end
               else
                  redirect_to root_path
               end
            elsif(type == "edit" || type == "update" || type == "destroy")
               if(current_user && current_user.admin)
                  faqFound = Faq.find_by_title(params[:id])
                  if(faqFound)
                     @faq = faqFound
                     if(type == "update")
                        if(@faq.update_attributes(params[:faq]))
                           flash[:success] = "Faq #{@faq.title} was successfully updated."
                           redirect_to faqs_path
                        else
                           render "edit"
                        end
                     elsif(type == "destroy")
                        flash[:success] = "Faq #{@faq.title} was successfully removed."
                        @faq.destroy
                        redirect_to faqs_path
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
