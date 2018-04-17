class FeedPost < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :flights
  has_many :waypoints, through: :flights
  has_many :ratings

  def airports
    flights.pluck(:from_id, :to_id).flatten
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
