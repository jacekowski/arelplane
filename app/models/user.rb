class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :flights

  def trips_lat_long
    my_flights = []
    flights.each do |flight|
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
      my_flights << trip_cords
    end
    my_flights
  end

  def visited_airports
    my_locations = {}
    flights.each do |flight|
      from_lat = flight.from.latitude
      from_long = flight.from.longitude
      to_lat = flight.to.latitude
      to_long = flight.to.longitude

      if data = my_locations[flight.from.identifier]
        data[1] += 1
      else
        my_locations[flight.from.identifier] = [[from_lat, from_long], 0]
      end
      if data = my_locations[flight.to.identifier]
        data[1] += 1
      else
        my_locations[flight.to.identifier] = [[to_lat, to_long], 0]
      end
    end
    my_locations
  end

  def visited_waypoints
    waypoints = {}
    flights.each do |flight|
      flight.waypoints.each do |wp|
        waypoints[wp.location.identifier] = [wp.location.latitude, wp.location.longitude]
      end
    end
    waypoints
  end
end
