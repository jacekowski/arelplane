class NewsFeed
  def user_feed
    user_ids = Flight.order(created_at: :desc).pluck(:user_id).uniq
    User.find(user_ids)
  end

end
