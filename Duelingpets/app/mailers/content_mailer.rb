class ContentMailer < ActionMailer::Base

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

