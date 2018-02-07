class UserMailer < ActionMailer::Base

   def welcome(user)
      @user = user
      mail(to: @user.email, from: "notification@duelingpets.net", subject: "Welcome #{@user.vname}:[Duelingpets]")
   end

   def contact(name, email, subject, body)
      @name = name
      @email = email
      @subject = subject
      @body = body
      mail(to: "contactduelingpets@gmail.com", from: @email, subject: "#{@name}: #{@subject} [Duelingpets]")
   end

   def account_info(user)
      @user = user
      mail(to: @user.email, from: "notification@duelingpets.net", subject: "Account info:[Duelingpets]")
   end

   def login_info(user, password)
      @user = user
      @password = password
      mail(to: @user.email, from: "notification@duelingpets.net", subject: "Login info:[Duelingpets]")
   end

   def reset_password(user)
      @user = user
      mail(to: @user.email, from: "notification@duelingpets.net", subject: "Reset password:[Duelingpets]")
   end

   def reset_time(user)
      @user = user
      mail(to: @user.email, from: "notification@duelingpets.net", subject: "Reset time:[Duelingpets]")
   end

   def bot_registration(registration)
      @registration = registration
      mail(to: "contactduelingpets@gmail.com", from: "notification@duelingpets.net", subject: "New bot: #{@registration.vname} [Duelingpets]")
   end

   def registration_review(registration)
      @registration = registration
      @url = "http://www.duelingpets.net/registrations"
      allPouches = Pouch.all
      keymasters = allPouches.select{|pouch| pouch.privilege == "Keymaster"}
      if(keymasters.count > 0)
         keymasters.each do |keymaster|
            mail(to: keymaster.user.email, from: "notification@duelingpets.net", subject: "New registration #{@registration.vname} is awaiting review [Duelingpets]")
         end
      end
   end

   def pm_sent(pm)
      @pm = pm
      @url = "http://www.duelingpets.net/pms/inbox"
      mail(to: @pm.to_user.email, from: "notification@duelingpets.net", subject: "#{@pm.from_user.vname} sent you a PM. [Duelingpets]")
   end

   def pmreply_sent(pmreply)
      @pmreply = pmreply
      @url = "http://www.duelingpets.net/pms/inbox"
      emailUser = nil
      if(pmreply.user_id == pmreply.pm.from_user_id)
         emailUser = @pmreply.pm.to_user.email
      elsif(pmreply.user_id == pmreply.pm.to_user.id)
         emailUser = @pmreply.pm.from_user.email
      end
      if(emailUser != nil)
         mail(to: emailUser, from: "notification@duelingpets.net", subject: "#{@pmreply.user.vname} sent you a new PMReply. [Duelingpets]")
      end
   end

   def user_referral(referral, points)
      @referral = referral
      @points = points
      mail(to: @referral.referred_by.email, from: "notification@duelingpets.net", subject: "#{@referral.to_user.vname} was referred by you. [Duelingpets]")
   end

   def goal_reached(box, points, netPoints)
      @donationbox = box
      @points = points
      @netpoints = netpoints
      mail(to: @donationbox.user.email, from: "notification@duelingpets.net", subject: "Congratulations #{@donationbox.user.vname} you hit your goal!")
   end

   def sound_favorited(sound, points)
      @favoritesound = sound
      @points = points
      mail(to: @favoritesound.sound.user.email, from: "notification@duelingpets.net", subject: "Your sound #{@favoritesound.sound.title} was favorited by #{@favoritesound.user.vname}.")
   end

   def sound_starred(sound, points)
      @soundstar = sound
      @points = points
      mail(to: @soundstar.sound.user.email, from: "notification@duelingpets.net", subject: "Your sound #{@soundstar.sound.title} was starred by #{@soundstar.user.vname}.")
   end

   def sound_critiqued(sound, points)
      @soundcomment = sound
      @points = points
      mail(to: @soundcomment.sound.user.email, from: "notification@duelingpets.net", subject: "Your sound #{@soundcomment.sound.title} was critiqued by #{@soundcomment.user.vname}.")
   end

   def art_favorited(art, points)
      @favoriteart = art
      @points = points
      mail(to: @favoriteart.art.user.email, from: "notification@duelingpets.net", subject: "Your art #{@favoriteart.art.title} was favorited by #{@favoriteart.user.vname}.")
   end

   def art_starred(art, points)
      @artstar = art
      @points = points
      mail(to: @artstar.art.user.email, from: "notification@duelingpets.net", subject: "Your art #{@artstar.art.title} was starred by #{@artstar.user.vname}.")
   end

   def art_critiqued(art, points)
      @artcomment = art
      @points = points
      mail(to: @artcomment.art.user.email, from: "notification@duelingpets.net", subject: "Your art #{@artcomment.art.title} was critiqued by #{@artcomment.user.vname}.")
   end

   def movie_favorited(movie, points)
      @favoritemovie = movie
      @points = points
      mail(to: @favoritemovie.movie.user.email, from: "notification@duelingpets.net", subject: "Your movie #{@favoritemovie.movie.title} was favorited by #{@favoritemovie.user.vname}.")
   end

   def movie_starred(movie, points)
      @moviestar = movie
      @points = points
      mail(to: @moviestar.movie.user.email, from: "notification@duelingpets.net", subject: "Your movie #{@moviestar.movie.title} was starred by #{@moviestar.user.vname}.")
   end

   def movie_critiqued(movie, points)
      @moviecomment = movie
      @points = points
      mail(to: @moviecomment.movie.user.email, from: "notification@duelingpets.net", subject: "Your movie #{@moviecomment.movie.title} was critiqued by #{@moviecomment.user.vname}.")
   end

   def blog_starred(blog, points)
      @blogstar = blog
      @points = points
      mail(to: @blogstar.blog.user.email, from: "notification@duelingpets.net", subject: "Your blog #{@blogstar.blog.title} was starred by #{@blogstar.user.vname}.")
   end
end
