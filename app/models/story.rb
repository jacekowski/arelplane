class Story < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :flights, inverse_of: :story

  accepts_nested_attributes_for :flights, reject_if: :reject_flight

  has_many :waypoints, through: :flights
  has_many :destinations, through: :flights, source: :destination
  has_many :origins, through: :flights, source: :origin
  has_many :ratings

  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy

  def reject_flight(attributes)
    attributes['origin_id'].blank? &&
    attributes['destination_id'].blank?
  end

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
