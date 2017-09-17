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
        f.add_waypoints(r, " ", :route, :from_id, :to_id)
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

  def self.parse_safelog(logbook_csv, user)
    CSV.foreach(logbook_csv, {headers: true}) do |row|
        r = row.to_hash
        next unless date_format_one =~ r["Date"]
        f = Flight.find_or_initialize_by(
        user_id: user.id,
        flight_date: r["Date"].to_date,
        aircraft_id: r["Aircraft Registration"],
        from_id: Location.find_by(identifier: r["Mission Departure"]).try(:id) || 0,
        to_id: Location.find_by(identifier: r["Mission Arrival"]).try(:id) || 0,
        pic: r["Day Single-Engine (SE) Pilot"],
        total_time: r["Mission Duration"]
        )
      if f.new_record?
        f.save
        f.add_waypoints(r, ":", "Mission Via", "Mission Departure", "Mission Arrival")
      end
    end
  end

  def add_waypoints(logbook_row, delimiter, waypoint_column, from_column, to_column)
    if route = logbook_row[waypoint_column]
      route = route.split(delimiter)
      # save route, but check if first and last values are same as start and end.
      if route.first == logbook_row[from_column] then route.shift end
      if route.last == logbook_row[to_column] then route.pop end
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
