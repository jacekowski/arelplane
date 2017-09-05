class Flight < ApplicationRecord
  belongs_to :from, class_name: 'Location', foreign_key: 'from_id'
  belongs_to :to, class_name: 'Location', foreign_key: 'to_id'
  belongs_to :user

  has_many :waypoints, foreign_key: "flight_id", class_name: "FlightWaypoint", dependent: :destroy

  # Homepage map
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

  def self.visited_waypoints
    waypoints = {}
    all.each do |flight|
      flight.waypoints.each do |wp|
        waypoints[wp.location.identifier] = [wp.location.latitude, wp.location.longitude]
      end
    end
    waypoints
  end

  def self.parse_logbook(logbook_csv, user)
    date_format_one = /^\d{4}-{1}\d{2}-{1}\d{2}$/
    date_format_two = /^\d{2}\/{1}\d{2}\/{1}\d{4}$/
    CSV.foreach(logbook_csv, headers: [
      :flight_date,
      :aircraft_id,
      :from_id,
      :to_id,
      :route,
      :time_out,
      :time_in,
      :on_duty,
      :off_duty,
      :total_time,
      :pic,
      :sic,
      :night,
      :solo,
      :cross_country,
      :distance
      ]) do |row|
        r = row.to_hash
        next unless (date_format_one =~ r[:flight_date] || date_format_two =~ r[:flight_date])
        f = Flight.find_or_initialize_by(
          user_id: user.id,
          flight_date: r[:flight_date],
          aircraft_id: r[:aircraft_id],
          from_id: Location.find_by(identifier: r[:from_id]).try(:id),
          to_id: Location.find_by(identifier: r[:to_id]).try(:id),
          time_out: r[:time_out],
          time_in: r[:time_in],
          total_time: r[:total_time],
          pic: r[:pic],
          distance: r[:distance]
        )
      if f.new_record?
        f.save
        f.add_waypoints(r)
      end
    end
  end

  def add_waypoints(logbook_row)
    if route = logbook_row[:route]
      route = route.split(" ")
      # save route, but check if first and last values are same as start and end.
      if route.first == logbook_row['From'] then route.shift end
      if route.last == logbook_row['To'] then route.pop end
      route.each do |waypoint|
        waypoints.create(location_id: Location.find_by(identifier: waypoint).try(:id))
      end
    end

  end

end
