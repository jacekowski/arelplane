class FlightWaypoint < ApplicationRecord
  belongs_to :flight
  belongs_to :location
end
