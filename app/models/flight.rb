class Flight < ApplicationRecord
  belongs_to :from, class_name: 'Location', foreign_key: 'from_id'
  belongs_to :to, class_name: 'Location', foreign_key: 'to_id'

  has_many :waypoints, foreign_key: "flight_id", class_name: "FlightWaypoint"

  def self.trips_lat_long
    flights = []
    all.each do |flight|
      from_lat = flight.from.latitude
      from_long = flight.from.longitude
      to_lat = flight.to.latitude
      to_long = flight.to.longitude

      trip_cords = []
      trip_cords << [from_lat, from_long]
      flight.waypoints.each do |wp|
        trip_cords << [wp.location.latitude, wp.location.longitude]
      end
      trip_cords << [to_lat, to_long]
      flights << trip_cords
    end
    flights
  end

  def self.visited_airports
    locations = {}
    all.each do |flight|
      from_lat = flight.from.latitude
      from_long = flight.from.longitude
      to_lat = flight.to.latitude
      to_long = flight.to.longitude

      if data = locations[flight.from.identifier]
        data[1] += 1
      else
        locations[flight.from.identifier] = [[from_lat, from_long], 0]
      end
      if data = locations[flight.to.identifier]
        data[1] += 1
      else
        locations[flight.to.identifier] = [[to_lat, to_long], 0]
      end
    end
    locations
  end

# {khpn: [[lat,long,]12]}

  def self.visited_waypoints
    waypoints = {}
    all.each do |flight|
      flight.waypoints.each do |wp|
        waypoints[wp.location.identifier] = [wp.location.latitude, wp.location.longitude]
      end
    end
    waypoints
  end

end
