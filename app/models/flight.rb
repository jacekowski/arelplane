class Flight < ApplicationRecord
  belongs_to :from, class_name: 'Location', foreign_key: 'from_id'
  belongs_to :to, class_name: 'Location', foreign_key: 'to_id'
  belongs_to :user

  has_many :waypoints, foreign_key: "flight_id", class_name: "FlightWaypoint", dependent: :destroy

  def self.map_data
    map_data = {
      type: :FeatureCollection,
      max_count: 0,
      features: []
    }

    all.each do |flight|
      from = flight.from
      from_cords = [from.longitude.to_f, from.latitude.to_f]

      to = flight.to
      to_cords = [to.longitude.to_f, to.latitude.to_f]

      line_feature = {
        type: :Feature,
        properties: {
          count: 0,
          feature_type: :line
        },
        geometry: {
          type: :LineString,
          coordinates: []
        }
      }

      from_airport = {type: :Feature, properties: {count: 1}, geometry: {type: :Point}}
      to_airport = {type: :Feature, properties: {count: 1}, geometry: {type: :Point}}
      f = map_data[:features].find {|feature| feature[:properties][:identifier] == from.identifier }
      if f
        f[:properties][:count] += 1
      else
        from_airport[:properties][:feature_type] = :airport
        from_airport[:properties][:name] = from.name
        from_airport[:properties][:identifier] = from.identifier
        from_airport[:geometry][:coordinates] = from_cords
        map_data[:features] << from_airport
      end
      f = map_data[:features].find {|feature| feature[:properties][:identifier] == to.identifier }
      if f
        f[:properties][:count] += 1
      else
        to_airport[:properties][:feature_type] = :airport
        to_airport[:properties][:name] = to.name
        to_airport[:properties][:identifier] = to.identifier
        to_airport[:geometry][:coordinates] = to_cords
        map_data[:features] << to_airport
      end

      line_feature[:geometry][:coordinates] << from_cords

      flight.waypoints.each do |waypoint|
        location = waypoint.location
        waypoint_cords = [location.longitude.to_f, location.latitude.to_f]

        waypoint_data = {type: :Feature, properties: {count: 1}, geometry: {type: :Point}}
        f = map_data[:features].find {|feature| feature[:properties][:identifier] == location.identifier}
        if f
          f[:properties][:count] += 1
        else
          waypoint_data[:properties][:feature_type] = :waypoint
          waypoint_data[:properties][:name] = location.name
          waypoint_data[:properties][:identifier] = location.identifier
          waypoint_data[:geometry][:coordinates] = waypoint_cords
          map_data[:features] << waypoint_data
        end

        line_feature[:geometry][:coordinates] << waypoint_cords
      end
      line_feature[:geometry][:coordinates] << to_cords
      map_data[:features] << line_feature
    end
    map_data[:max_count] = map_data[:features].max_by {|f| f[:properties][:count]}[:properties][:count]
    map_data
  end

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

  def self.parse_foreflight(logbook_csv, user)
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
        next unless date_format_one =~ r[:flight_date]
        f = Flight.find_or_initialize_by(
          user_id: user.id,
          flight_date: r[:flight_date].to_date,
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

  def self.parse_logtenpro(logbook_csv, user)
    CSV.foreach(logbook_csv, { col_sep: "\t", headers: true}) do |row|
        r = row.to_hash
        next unless date_format_one =~ r["Date"]
        f = Flight.find_or_initialize_by(
          user_id: user.id,
          flight_date: r["Date"].to_date,
          aircraft_id: r["Aircraft ID"],
          from_id: Location.find_by(identifier: r["From"]).try(:id),
          to_id: Location.find_by(identifier: r["To"]).try(:id),
          total_time: r["Total Time"],
          pic: r["PIC"],
        )
      if f.new_record?
        f.save
      end
    end
  end

  {"mcc_DATE"=>"28/09/2016", "Is_PREVEXP"=>nil, "AC_IsSIM"=>nil, "FlightNumber"=>nil, "AF_DEP"=>"RTD", "TIME_DEP"=>"09:45", "TIME_DEPSCH"=>"00:00", "AF_ARR"=>"RTD", "TIME_ARR"=>"10:45", "TIME_ARRSCH"=>"00:00", "AC_MODEL"=>"150-Aerobatic", "AC_REG"=>"G-BBTB", "PILOT1_ID"=>nil, "PILOT1_NAME"=>"Stephen Waddy", "PILOT1_PHONE"=>nil, "PILOT1_EMAIL"=>nil, "PILOT2_ID"=>nil, "PILOT2_NAME"=>"SELF", "PILOT2_PHONE"=>"+447572224769", "PILOT2_EMAIL"=>"AlfieAllen69@gmail.com", "PILOT3_ID"=>nil, "PILOT3_NAME"=>nil, "PILOT3_PHONE"=>nil, "PILOT3_EMAIL"=>nil, "PILOT4_ID"=>nil, "PILOT4_NAME"=>nil, "PILOT4_PHONE"=>nil, "PILOT4_EMAIL"=>nil, "TIME_TOTAL"=>"60", "TIME_PIC"=>"0", "TIME_PICUS"=>"0", "TIME_SIC"=>"0", "TIME_DUAL"=>"60", "TIME_INSTRUCTOR"=>"0", "TIME_EXAMINER"=>"0", "TIME_NIGHT"=>"0", "TIME_RELIEF"=>"0", "TIME_IFR"=>"0", "TIME_ACTUAL"=>"0", "TIME_HOOD"=>"0", "TIME_XC"=>"0", "PF"=>"True", "TO_DAY"=>"1", "TO_NIGHT"=>"0", "LDG_DAY"=>"1", "LDG_NIGHT"=>"0", "AUTOLAND"=>"0", "HOLDING"=>"0", "LIFT"=>"0", "INSTRUCTION"=>nil, "REMARKS"=>"P/ut", "APP_1"=>nil, "APP_2"=>nil, "APP_3"=>nil, "Pax"=>"0", "DEICE"=>"False", "FUEL"=>"0", "FUELUSED"=>"0", "DELAY"=>"0", "FLIGHTLOG"=>nil, "TIME_TO"=>"00:00", "TIME_LDG"=>"00:00", "TIME_AIR"=>"0"}

  def self.parse_mccpilotlog(logbook_csv, user)
    CSV.foreach(logbook_csv, { col_sep: ";", headers: true}) do |row|
        r = row.to_hash
        next unless date_format_two =~ r["mcc_DATE"]
        f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["mcc_DATE"].to_date,
        aircraft_id: r["AC_REG"],
        from_id: Location.find_by(identifier: r["AF_DEP"]).try(:id),
        to_id: Location.find_by(identifier: r["AF_ARR"]).try(:id),
        time_out: r["TIME_DEP"],
        time_in: r["TIME_ARR"],
        total_time: r["TIME_TOTAL"].to_f/60,
        pic: r["TIME_TOTAL"]
        )
      if f.new_record?
        f.save
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

private
  def self.date_format_one
    /^\d{4}-{1}\d{2}-{1}\d{2}$/
  end

  def self.date_format_two
    /^\d{2}\/{1}\d{2}\/{1}\d{4}$/
  end

end
