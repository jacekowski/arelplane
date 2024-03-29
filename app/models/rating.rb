class Rating < ApplicationRecord
  has_many :user_ratings
  has_many :users, through: :user_ratings
  has_many :stories, through: :user_ratings
end
