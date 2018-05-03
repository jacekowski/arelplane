class UserRating < ApplicationRecord
  belongs_to :user
  belongs_to :rating
  belongs_to :story, optional: true
end
