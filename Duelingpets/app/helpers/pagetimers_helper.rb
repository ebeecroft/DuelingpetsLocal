module PagetimersHelper

   private
      def validTimeformat(pageTimer)
         value = 0
         if(pageTimer.duration == 1)
            if(pageTimer.timeformat == "Sec")
               value = duration.sec.from_now.utc
            elsif(pageTimer.timeformat == "Min")
               value = duration.min.from_now.utc
            elsif(pageTimer.timeformat == "Hour")
               value = duration.hour.from_now.utc
            elsif(pageTimer.timeformat == "Day")
               value = duration.day.from_now.utc
            elsif(pageTimer.timeformat == "Week")
               value = duration.week.from_now.utc
            elsif(pageTimer.timeformat == "Month")
               value = duration.month.from_now.utc
            elsif(pageTimer.timeformat == "Year")
               value = duration.year.from_now.utc
            end
         else
            if(pageTimer.timeformat == "Secs")
               value = duration.secs.from_now.utc
            elsif(pageTimer.timeformat == "Mins")
               value = duration.mins.from_now.utc
            elsif(pageTimer.timeformat == "Hours")
               value = duration.hours.from_now.utc
            elsif(pageTimer.timeformat == "Days")
               value = duration.days.from_now.utc
            elsif(pageTimer.timeformat == "Weeks")
               value = duration.weeks.from_now.utc
            elsif(pageTimer.timeformat == "Months")
               value = duration.months.from_now.utc
            elsif(pageTimer.timeformat == "Years")
               value = duration.years.from_now.utc
            end
         end
         return value
      end

      def mode(type)
         if(timeExpired)
            logout_user
            redirect_to root_path
         else
            if(current_user &&  current_user.admin)
               if(type == "index")
                  allTimers = Pagetimer.order("id desc")
                  @pagetimers = Kaminari.paginate_array(allTimers).page(params[:page]).per(10)
               elsif(type == "new" || type == "create")
                  newTimer = Pagetimer.new
                  value = 0
                  if(type == "create")
                     newTimer = Pagetimer.new(params[:pagetimer])
                     value = validTimeformat(newTimer)
                  end
                  newTimer.expiretime = value
                  @pagetimer = newTimer
                  if(type == "create")
                     if(value != 0)
                        if(@pagetimer.save)
                           flash[:success] = "The pagetimer #{@pagetimer.name} has been successfully created."
                           redirect_to pagetimers_path
                        else
                           render "new"
                        end
                     else
                        redirect_to root_path
                     end
                  end
               elsif(type == "edit" || type == "update" || type == "destroy")
                  timerFound = Pagetimer.find_by_name(params[:id])
                  if(timerFound)
                     @pagetimer = timerFound
                     if(type == "update")
                        value = validTimeformat(timerFound)
                        timerFound.expiretime = value
                        @pagetimer = timerFound
                        if(value != 0)
                           if(@pagetimer.update_attributes(params[:pagetimer]))
                              flash[:success] = "The pagetimer #{@pagetimer.name} was successfully updated."
                              redirect_to pagetimers_path
                           else
                              render "edit"
                           end
                        else
                           redirect_to root_path
                        end
                     elsif(type == "destroy")
                        flash[:success] = "The pagetimer #{@pagetimer.name} was successfully removed."
                        @pagetimer.destroy
                        redirect_to pagetimers_path
                     end
                  else
                     render "start/crazybat"
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
