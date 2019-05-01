class Location < ApplicationRecord
  has_paper_trail
  has_many :flights, class_name: 'Flight', foreign_key: 'origin_id'
  has_many :flights, class_name: 'Flight', foreign_key: 'destination_id'
  has_many :users, foreign_key: 'home_base'

  has_many :flight_waypoints

  validates :latitude, uniqueness: { scope: :longitude }

  def identifier=(val)
    write_attribute :identifier, val.upcase
  end

  def name_and_identifier
    if name
      identifier + " (#{name})"
    else
      identifier
    end
  end

  def self.convert_cords(cord)
    degree = cord.split("°").first.to_f
    minute = cord.split("'").first.split("°").second.to_f
    second = cord.split("'").second.to_f
    degree + (minute/60.0) + (second/3600.0)
  end

  def self.find_from(identifier)
    locations = where(identifier: identifier.try(:upcase).try(:strip))
    case locations.count
    when 0
      find_by(identifier: "XXXX").id
    when 1
      locations.first.id
    else
      last_location = Flight.last.origin
      results = {}
      locations.each do |location|
        distance = Geocoder::Calculations.distance_between([location.latitude,location.longitude], [last_location.latitude,last_location.longitude])
        if distance.nan?
          results[location] = 0
        else
          results[location] = distance
        end
      end
      results.sort_by(&:last).flatten.first.try(:id) || find_by(identifier: "XXXX").id
    end
  end

  def rollback_unless_authorized(user)
    temp_version = self.versions.last
    unless user.role == "admin"
      self.update_attributes(self.paper_trail.previous_version.attributes)
      notify_admin(user)
    end
    temp_version.destroy
  end

  def notify_admin(user)
    LocationMailer.update_submitted(self).deliver_later
  end

end
