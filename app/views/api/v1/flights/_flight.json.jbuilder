json.extract! flight, :id, :flight_date, :aircraft_identifier, :origin_id, :destination_id, :time_out, :time_in, :total_time, :pic, :distance, :created_at, :updated_at, :user_id
json.waypoints flight.waypoints
json.url flight_url(flight, format: :json)
