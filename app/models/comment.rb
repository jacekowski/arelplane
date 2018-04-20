class Comment < ApplicationRecord
  default_scope { order(created_at: :asc) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
