class FeedPost < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :flights
  has_many :waypoints, through: :flights
  has_many :destinations, through: :flights, source: :destination
  has_many :origins, through: :flights, source: :origin
  has_many :ratings

  has_many :likes, foreign_key: 'feed_post_id', class_name: "PostLike", dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :comments, as: :commentable

  def locations
    (origins + destinations).uniq
  end

  def airports
    flights.pluck(:origin_id, :destination_id).flatten
  end

  def num_airports
    waypoints.each do |wp|
      if wp.location.location_type.try(:include?, "airport")
        airports << wp.location.id
      end
    end
    airports.flatten.uniq.count
  end

  def total_flight_hours
    flights.pluck(:total_time).compact.sum.round(1)
  end

  def num_regions
    locations = (waypoints.pluck(:location_id) + airports).flatten
    Location.find(locations.uniq).pluck(:iso_region).uniq.count
  end

end
