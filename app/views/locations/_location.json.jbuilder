json.extract! location, :id, :identifier, :location_type, :name, :latitude, :longitude, :elevation, :continent, :iso_country, :iso_region, :municipality, :scheduled_service, :gps_code, :iata_code, :local_code, :home_link, :wikipedia_link, :keywords, :created_at, :updated_at
json.url location_url(location, format: :json)
