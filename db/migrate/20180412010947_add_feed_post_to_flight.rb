class AddFeedPostToFlight < ActiveRecord::Migration[5.1]
  def change
    add_reference :flights, :feed_post, foreign_key: true
    add_reference :ratings, :feed_post, foreign_key: true
  end
end
