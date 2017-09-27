class Flight < ApplicationRecord
  paginates_per 50

  belongs_to :from, class_name: 'Location', foreign_key: 'from_id'
  belongs_to :to, class_name: 'Location', foreign_key: 'to_id'
  belongs_to :user

  validates :flight_date, presence: true

  has_many :waypoints, foreign_key: "flight_id", class_name: "FlightWaypoint", dependent: :destroy

  def self.map_data(flights)
    map_data = feature_collection
    flights.all.each do |flight|
      departure_location = flight.from
      arrival_location = flight.to
      line_feature = line_feature_structure

      add_or_increment_location(map_data, departure_location, :airport)
      add_or_increment_location(map_data, arrival_location, :airport)

      line_feature[:geometry][:coordinates] << get_coordinates(departure_location)
      add_or_increment_waypoint_data(flight, map_data, line_feature)
      line_feature[:geometry][:coordinates] << get_coordinates(arrival_location)
      map_data[:features] << line_feature
    end
    set_top_visited_airport_count(map_data)
    map_data
  end

  def self.add_feature_to_map(feature_collection, feature, location, feature_type)
    feature[:properties][:feature_type] = feature_type
    feature[:properties][:name] = location.name
    feature[:properties][:identifier] = location.identifier
    feature[:geometry][:coordinates] = [location.longitude.to_f, location.latitude.to_f]
    feature_collection[:features] << feature
  end

  def self.increment_feature_count(feature, feature_type)
    feature[:properties][:feature_type] = feature_type unless feature_type == :waypoint
    feature[:properties][:count] += 1
  end

  def self.find_feature_if_exists(feature_collection, location)
    feature_collection[:features].find {|feature| feature[:properties][:identifier] == location.identifier }
  end

  def self.get_coordinates(location)
    [location.longitude.to_f, location.latitude.to_f]
  end

  def self.add_or_increment_location(feature_collection, location, feature_type)
    if feature = find_feature_if_exists(feature_collection, location)
      increment_feature_count(feature, feature_type)
    else
      add_feature_to_map(feature_collection, point_feature_structure, location, feature_type)
    end
  end

  def self.set_top_visited_airport_count(map_data)
    if map_data[:features].count > 0
      map_data[:max_count] = map_data[:features].max_by {|f| f[:properties][:count]}[:properties][:count]
    else
      map_data[:max_count]
    end
  end

  def self.add_or_increment_waypoint_data(flight, feature_collection, line_feature)
    flight.waypoints.each do |waypoint|
      location = waypoint.location
      add_or_increment_location(feature_collection, location, :waypoint)
      line_feature[:geometry][:coordinates] << get_coordinates(location)
    end
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
          from_id: Location.find_by(identifier: r[:from_id].try(:upcase)).try(:id),
          to_id: Location.find_by(identifier: r[:to_id].try(:upcase)).try(:id),
          time_out: r[:time_out],
          time_in: r[:time_in],
          total_time: r[:total_time],
          pic: r[:pic],
          distance: r[:distance]
        )
      if f.new_record?
        if f.save
          f.add_waypoints(r, :route, :from_id, :to_id)
        end
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
        from_id: Location.find_by(identifier: r["From"].try(:upcase)).try(:id),
        to_id: Location.find_by(identifier: r["To"].try(:upcase)).try(:id),
        total_time: r["Total Time"],
        pic: r["PIC"],
      )
      if f.new_record?
        f.save
      end
    end
  end

  def self.parse_mccpilotlog(logbook_csv, user)
    file = logbook_csv.read.gsub(/[^\.0-9A-Za-z\s,;:@"\/_()&\\-]/, '')
    CSV.parse(file, {col_sep: ";", headers: true} ) do |row|
      r = row.to_hash
      next unless date_format_two =~ r["mcc_DATE"]
      f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["mcc_DATE"].to_date,
        aircraft_id: r["AC_REG"],
        from_id: Location.find_by(identifier: r["AF_DEP"].try(:upcase)).try(:id),
        to_id: Location.find_by(identifier: r["AF_ARR"].try(:upcase)).try(:id),
        time_out: r["TIME_DEP"],
        time_in: r["TIME_ARR"],
        total_time: r["TIME_TOTAL"].to_f/60,
        pic: r["TIME_TOTAL"].to_f/60
      )
      if f.new_record?
        f.save
      end
    end
  end

  def self.parse_safelog(logbook_csv, user)
    file = File.read(logbook_csv).gsub(/\r/," ")
    CSV.parse(file, headers: true, skip_blanks: true) do |row|
      r = row.to_hash
      next unless date_format_one =~ r["Date"]
      f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["Date"].to_date,
        aircraft_id: r["Aircraft Registration"],
        from_id: get_safelog_departure(row),
        to_id: get_safelog_arrival(row),
        time_out: r["Depart Time"],
        time_in: r["Arrival Time"],
        pic: r["Day Single-Engine (SE) Pilot"] || r["Day Single-Engine (SE) in Command"],
        total_time: r["Mission Duration"] || r["Total Flight Time"]
      )
      if f.new_record?
        if f.save
          f.add_waypoints(r, "Mission Via", "Mission Departure", "Mission Arrival")
        end
      end
    end
  end

  def self.parse_zululog(logbook_csv, user)
    CSV.foreach(logbook_csv, {headers: true}) do |row|
      r = row.to_hash
      next unless date_format_three =~ r["Date"]
      route = r["Route"].scan(/[\w']+/)
      f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["Date"].to_date,
        aircraft_id: r["Aircraft ID"],
        from_id: Location.find_by(identifier: route.first.try(:upcase)).try(:id),
        to_id: Location.find_by(identifier: route.last.try(:upcase)).try(:id),
        pic: r["PIC"],
        total_time: r["Total Time"]
      )
      if f.new_record?
        if f.save
          route.shift
          route.pop
          route.each do |waypoint|
            f.waypoints.create(location_id: Location.find_by(identifier: waypoint.try(:upcase)).try(:id))
          end
        end
      end
    end
  end

  def self.parse_myflightbook(logbook_csv, user)
    file = File.read(logbook_csv).gsub(/[^\.0-9A-Za-z\s,"\/\\-]/, '')
    delimiter = sniff(logbook_csv)
    CSV.parse(file, {col_sep: delimiter, headers: true} ) do |row|
      r = row.to_hash
      if raw_route = r["Route"]
        route = raw_route.scan(/[\w']+/)
        f = Flight.find_or_initialize_by(
          user_id: user.id,
          flight_date: string_to_date(r["Date"]),
          aircraft_id: r["Tail Number"],
          from_id: Location.find_by(identifier: route.first.try(:upcase)).try(:id),
          to_id: Location.find_by(identifier: route.last.try(:upcase)).try(:id),
          time_out: r["Engine Start"],
          time_in: r["Engine End"],
          pic: r["PIC"],
          total_time: r["Total Flight Time"]
        )
        if f.new_record?
          if f.save
            route.shift
            route.pop
            route.each do |waypoint|
              f.waypoints.create(location_id: Location.find_by(identifier: waypoint.try(:upcase)).try(:id))
            end
          end
        end
      end
    end
  end

  def self.parse_logbookpro(logbook_csv, user)
    file = File.read(logbook_csv).gsub(/[\"\r]/," ")
    CSV.parse(file, headers: true, skip_blanks: true) do |row|
      r = row.to_hash
      next unless date_format_two =~ r["DATE"]
      route = r["ROUTE OF FLIGHT"].scan(/[\w']+/)
      f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: Date.strptime(r["DATE"], "%m/%d/%Y"),
        aircraft_id: r["AIRCRAFT IDENT"],
        from_id: Location.find_by(identifier: route.first.try(:upcase)).try(:id),
        to_id: Location.find_by(identifier: route.last.try(:upcase)).try(:id),
        pic: r["PILOT IN COMMAND"],
        total_time: r["DURATION"]
      )
      if f.new_record?
        if f.save
          route.shift
          route.pop
          route.each do |waypoint|
            f.waypoints.create(location_id: Location.find_by(identifier: waypoint.try(:upcase)).try(:id))
          end
        end
      end
    end
  end

  def self.parse_garmin_pilot(logbook_csv, user)
    CSV.parse(logbook_csv, headers: true, skip_blanks: true) do |row|
      r = row.to_hash
      next unless date_format_one =~ r["Date"]
      f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["Date"].to_date,
        aircraft_id: r["Aircraft ID"],
        from_id: Location.find_by(identifier: r["Departure"].try(:upcase)).try(:id),
        to_id: Location.find_by(identifier: r["Destination"].try(:upcase)).try(:id),
        time_out: r["Time Out"],
        time_in: r["Time In"],
        pic: r["PIC Duration"],
        total_time: r["Total Duration"]
      )
      if f.new_record?
        if f.save
          f.add_waypoints(r, "Route", "Departure", "Destination")
        end
      end
    end
  end

  def add_waypoints(logbook_row, waypoint_column, from_column, to_column)
    if route = logbook_row[waypoint_column]
      route = route.scan(/[\w']+/)
      # save route, but check if first and last values are same as start and end.
      if route.first == logbook_row[from_column] then route.shift end
      if route.last == logbook_row[to_column] then route.pop end
      route.each do |waypoint|
        waypoints.create(location_id: Location.find_by(identifier: waypoint.try(:upcase)).try(:id))
      end
    end
  end

private
  def self.date_format_one
    # 2017-09-09
    /^\d{4}-{1}\d{2}-{1}\d{2}$/
  end

  def self.date_format_two
    # 09/09/2017
    /^\d{2}\/{1}\d{2}\/{1}\d{4}$/
  end

  def self.date_format_three
    # Sep 10, 2017
    # Sep 9, 2017
    /^[a-zA-Z]{3}\s{1}\d{1,2}[,]{1}\s{1}\d{4}$/
  end

  def self.date_format_four
    # 9/7/17
    /^\d{1,2}\/{1}\d{1,2}\/{1}\d{2}$/
  end


  def self.sniff(path)
    delimiters = ['","',"\"\t\""]
    first_line = File.open(path).first
    return nil unless first_line
    snif = {}
    delimiters.each {|delim|snif[delim]=first_line.count(delim)}
    snif = snif.sort {|a,b| b[1]<=>a[1]}
    snif.size > 0 ? snif[0][0][1] : nil
  end

  def self.string_to_date(date_string)
    if date_format_one =~ date_string
      date_string.to_date
    elsif date_format_four =~ date_string
      Date.strptime(date_string, "%m/%d/%y")
    else
      date_string.to_date
    end
  end

  def self.get_safelog_departure(row)
    if identifier = row["Mission Departure"]
      Location.find_by(identifier: identifier).id
    else
      Location.find_by(identifier: row["Flight Details From"]).try(:id)
    end
  end

  def self.get_safelog_arrival(row)
    if identifier = row["Mission Arrival"]
      Location.find_by(identifier: identifier).id
    else
      Location.find_by(identifier: row["Flight Details To"]).try(:id)
    end
  end

  def self.feature_collection
    {
      type: :FeatureCollection,
      max_count: 0,
      features: []
    }
  end

  def self.point_feature_structure
    {
      type: :Feature,
      properties: {
        count: 0
      },
      geometry: {
        type: :Point
      }
    }
  end

  def self.line_feature_structure
    {
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
  end

end
