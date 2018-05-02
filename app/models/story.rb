class Story < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :flights
  accepts_nested_attributes_for :flights

  has_many :waypoints, through: :flights
  accepts_nested_attributes_for :waypoints, reject_if: lambda { |a| a[:location_id].blank? }

  has_many :destinations, through: :flights, source: :destination
  has_many :origins, through: :flights, source: :origin
  has_many :ratings

  has_many :post_comments, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy

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
