class PostLike < ApplicationRecord
  belongs_to :user
  belongs_to :feed_post
end
