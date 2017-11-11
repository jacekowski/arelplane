class FlightFeed
  def self.feed
    # show links to maps with recently added flights
    # continous scroll
    # you can scroll down to the first flight ever added to the website.
    # unique on user
    Flight.order(created_at: :desc).pluck(:user_id).uniq
  end
end
