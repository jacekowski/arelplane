class Location < ApplicationRecord
  has_many :flights, class_name: 'Flight', foreign_key: 'from_id'
  has_many :flights, class_name: 'Flight', foreign_key: 'to_id'

  has_many :flight_waypoints

  validates :latitude, uniqueness: { scope: :longitude }

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

end
