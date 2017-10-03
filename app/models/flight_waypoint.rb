class FlightWaypoint < ApplicationRecord
  belongs_to :flight, inverse_of: :waypoints
  belongs_to :location
  default_scope { order(created_at: :asc) }
end
