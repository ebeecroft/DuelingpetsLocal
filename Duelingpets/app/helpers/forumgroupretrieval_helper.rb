module ForumgroupretrievalHelper

   private
      def getBookGroups(user)
         groupValue = ""
         age = (currentTime.year - user.birthday.year)
         month = (currentTime.month - user.birthday.month) / 12
         if(month < 0)
            age -= 1
         end

         #Determines the group
         if(age < 7)
            groupValue = 0
         elsif(age < 13)
            groupValue = 1
         elsif(age < 19)
            groupValue = 2
         elsif(age < 25)
            groupValue = 3
         elsif(age < 31)
            groupValue = 4
         elsif(age < 37)
            groupValue = 5
         elsif(age >= 37)
            groupValue = 6
         end
         return groupValue
      end

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
end
