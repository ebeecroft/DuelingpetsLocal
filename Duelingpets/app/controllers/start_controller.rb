class StartController < ApplicationController
   include StartHelper

   def adjust
      music_value = ""
      if(checkMusicFlag == "On")
         music_value = "Off"
      else
         music_value = "On"
      end
      cookies[:music_on] = {:value => music_value}
      redirect_to root_path
   end

   def verify
      color_value = params[:session][:color].downcase
      if(color_value)
         if(color_value == "pink" || color_value == "red" || color_value == "blue" || color_value == "green" || color_value == "cyan" || color_value == "magenta" || color_value == "orange" || color_value == "brown" || color_value == "yellow")
            params[:session][:create] = color_value
            render "contact2"
         else
            flash[:error] = "Invalid color value"
            redirect_to root_path
         end
      else
         flash[:error] = "Invalid color value"
         redirect_to root_path
      end
   end

   def verify2
      name_value = params[:session][:name].downcase
      email_value = params[:session][:email].downcase
      subject_value = params[:session][:subject]
      body_value = params[:session][:body]
      if(name_value.empty? || email_value.empty? || subject_value.empty? || body_value.empty?)
         flash[:error] = "One of the parameters was empty please ensure all are filled in."
      else
         UserMailer.contact(name_value, email_value, subject_value, body_value).deliver
         flash[:success] = "Your message has now been sent."
      end
      redirect_to root_path
   end

   def home
      mode "home"
   end

   def stats
      mode "stats"
   end

   def contact
      mode "contact"
   end

   def sitemap
      mode "sitemap"
   end

   def active
      mode "active"
   end

   def revertcolor
      mode "revertcolor"
   end
end
