class Comment < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true
end
