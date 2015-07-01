# A user has many posts
# A user may favorite many posts
# A post may be favorited by many users
#
class User < ActiveRecord::Base
  has_many :posts
end

# A post belongs to exactly one user
class Post < ActiveRecord::Base
  belongs_to :user
end

class Follow < ActiveRecord::Base
  # A user may have many followers
  has_many :users

  # A user may follow many other users
  # User.followers
end


#
# User may be interested in many topics
# A topic may be of interest to many users
# 
