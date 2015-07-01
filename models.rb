class User < ActiveRecord::Base

end


# A user has many posts
# A post belongs to exactly one user
#
# A user may have many followers
# A user may follow many other users
#
# A user may favorite many posts
# A post may be favorited by many users
#
# User may be interested in many topics
# A topic may be of interest to many users
# 
