class Flight < ApplicationRecord
  belongs_to :from, class_name: 'Location', foreign_key: 'from_id'
  belongs_to :to, class_name: 'Location', foreign_key: 'to_id'

  def self.trips_lat_long
    flights = []
    all.each do |flight|
      from_lat = flight.from.latitude
      from_long = flight.from.longitude
      to_lat = flight.to.latitude
      to_long = flight.to.longitude

      flights << [[from_lat, from_long], [to_lat, to_long]]
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

      locations[flight.from.identifier] = [from_lat, from_long]
      locations[flight.to.identifier] = [to_lat, to_long]
    end
    locations
  end

end
