namespace :flight do
  desc "adding distance to flights"
  task add_distance: :environment do
    Flight.all.each do |flight|
      if !flight.distance
        puts "Updating #{flight.id} with distance"
        flight.add_distance
      end
    end
  end

  task add_aircraft_id: :environment do
    Flight.all.each do |flight|
      identifier = flight.aircraft_identifier
      if !flight.aircraft_id && identifier.present?
        flight.update_attributes(aircraft_id: Aircraft.find_by(identifier: identifier).try(:id))
        puts "Updating #{flight.id} with #{identifier}"
      end
    end
  end
end
