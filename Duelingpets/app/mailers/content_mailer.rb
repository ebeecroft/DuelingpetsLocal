class ContentMailer < ActionMailer::Base

   def topiccontainer_created(topiccontainer, points)
      @topiccontainer = topiccontainer
      @points = points
      mail(to: @topiccontainer.user.email, from: "notification@duelingpets.net", subject: "Your topiccontainer #{@topiccontainer.title} was created:[Duelingpets]")
   end

   def maintopic_created(maintopic, points)
      @maintopic = maintopic
      @points = points
      mail(to: @maintopic.user.email, from: "notification@duelingpets.net", subject: "Your maintopic #{@maintopic.title} was created:[Duelingpets]")
   end

   def subtopic_created(subtopic, points)
      @subtopic = subtopic
      @points = points
      mail(to: @subtopic.user.email, from: "notification@duelingpets.net", subject: "Your subtopic #{@subtopic.title} was created:[Duelingpets]")
   end

   def narrative_created(narrative, points)
      @narrative = narrative
      @points = points
      mail(to: @narrative.user.email, from: "notification@duelingpets.net", subject: "Your narrative #{@narrative.subtopic.title} was created:[Duelingpets]")
   end

   def sound_approved(sound, points)
      @sound = sound
      @points = points
      mail(to: @sound.user.email, from: "notification@duelingpets.net", subject: "Your sound #{@sound.title} was approved:[Duelingpets]")
   end

   def sound_denied(sound)
      @sound = sound
      mail(to: @sound.user.email, from: "notification@duelingpets.net", subject: "Your sound #{@sound.title} was denied:[Duelingpets]")
   end

   def sound_review(sound)
      @sound = sound
      @url = "http://localhost:3000/arts/review"
      allPouches = Pouch.all
      keymasters = allPouches.select{|pouch| pouch.privilege == "Keymaster"}
      if(keymasters.count > 0)
         keymasters.each do |keymaster|
            mail(to: keymaster.user.email, from: "notification@duelingpets.net", subject: "New sound #{@sound.title} is awaiting review:[Duelingpets]")
         end
      end

      reviewers = allPouches.select{|pouch| pouch.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, from: "notification@duelingpets.net", subject: "New sound #{@sound.title} is awaiting review:[Duelingpets]")
         end
      end
   end

   def art_approved(art, points)
      @art = art
      @points = points
      mail(to: @art.user.email, from: "notification@duelingpets.net", subject: "Your art #{@art.title} was approved:[Duelingpets]")
   end

   def art_denied(art)
      @art = art
      mail(to: @art.user.email, from: "notification@duelingpets.net", subject: "Your art #{@art.title} was denied:[Duelingpets]")
   end

   def art_review(art)
      @art = art
      @url = "http://localhost:3000/arts/review"
      allPouches = Pouch.all
      keymasters = allPouches.select{|pouch| pouch.privilege == "Keymaster"}
      if(keymasters.count > 0)
         keymasters.each do |keymaster|
            mail(to: keymaster.user.email, from: "notification@duelingpets.net", subject: "New art #{@art.title} is awaiting review:[Duelingpets]")
         end
      end

      reviewers = allPouches.select{|pouch| pouch.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, from: "notification@duelingpets.net", subject: "New art #{@art.title} is awaiting review:[Duelingpets]")
         end
      end
   end

   def movie_approved(movie, points)
      @movie = movie
      @points = points
      mail(to: @movie.user.email, from: "notification@duelingpets.net", subject: "Your movie #{@movie.title} was approved:[Duelingpets]")
   end

   def movie_denied(movie)
      @movie = movie
      mail(to: @movie.user.email, from: "notification@duelingpets.net", subject: "Your movie #{@movie.title} was denied:[Duelingpets]")
   end

   def movie_review(movie)
      @movie = movie
      @url = "http://localhost:3000/movies/review"
      allPouches = Pouch.all
      keymasters = allPouches.select{|pouch| pouch.privilege == "Keymaster"}
      if(keymasters.count > 0)
         keymasters.each do |keymaster|
            mail(to: keymaster.user.email, from: "notification@duelingpets.net", subject: "New movie #{@movie.title} is awaiting review:[Duelingpets]")
         end
      end

      reviewers = allPouches.select{|pouch| pouch.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, from: "notification@duelingpets.net", subject: "New movie #{@movie.title} is awaiting review:[Duelingpets]")
         end
      end
   end

   def blog_approved(blog, points)
      @blog = blog
      @points = points
      mail(to: @blog.user.email, from: "notification@duelingpets.net", subject: "Your blog #{@blog.title} was approved:[Duelingpets]")
   end

   def blog_denied(blog)
      @blog = blog
      mail(to: @blog.user.email, from: "notification@duelingpets.net", subject: "Your blog #{@blog.title} was denied:[Duelingpets]")
   end

   def blog_review(blog)
      @blog = blog
      @url = "http://localhost:3000/blogs/review"
      allPouches = Pouch.all
      keymasters = allPouches.select{|pouch| pouch.privilege == "Keymaster"}
      if(keymasters.count > 0)
         keymasters.each do |keymaster|
            mail(to: keymaster.user.email, from: "notification@duelingpets.net", subject: "New blog #{@blog.title} is awaiting review:[Duelingpets]")
         end
      end

      reviewers = allPouches.select{|pouch| pouch.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, from: "notification@duelingpets.net", subject: "New blog #{@blog.title} is awaiting review:[Duelingpets]")
         end
      end
   end

   def suggestion_applied(suggestion, points)
      @suggestion = suggestion
      @points = points
      mail(to: @suggestion.user.email, from: "notification@duelingpets.net", subject: "Your suggestion #{@suggestion.title} was applied:[Duelingpets]")
   end

   def suggestion_review(suggestion)
      @suggestion = suggestion
      @url = "http://localhost:3000/suggestions"
      allPouches = Pouch.all
      admins = allPouches.select{|pouch| pouch.privilege == "Admin"}
      if(admins.count > 0)
         admins.each do |admin|
            mail(to: admin.user.email, from: "notification@duelingpets.net", subject: "New suggestion #{@suggestion.title} is awaiting review:[Duelingpets]")
         end
      end
   end
end

