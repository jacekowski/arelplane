class FeedPost < ApplicationRecord
  belongs_to :user
  has_many :flights
  has_many :ratings
end
