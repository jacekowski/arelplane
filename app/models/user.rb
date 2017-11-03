class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, on: :create
  validates :username, presence: true,
                     uniqueness: {case_sensitive: false},
                     length: { maximum: 100 }

  has_many :flights, dependent: :destroy
  has_many :locations, through: :flights
  has_many :waypoints, through: :flights

  def locations
    (waypoints.pluck(:location_id) + airports).flatten
  end

  def airports
    flights.pluck(:from_id, :to_id).flatten
  end

  def top_location
    unless locations.empty?
      Location.find(locations.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]).identifier
    else
      nil
    end
  end

  def top_region
    unless locations.empty?
      Location.find(locations.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]).iso_region
    else
      nil
    end
  end

  def top_aircraft
    flights.group(:aircraft_id).order('count_id DESC').limit(1).count(:id).keys.first
  end

  def total_flight_hours
    flights.pluck(:total_time).compact.sum.round(1)
  end

  def num_airports
    airports.uniq.count
  end

  def num_regions
    Location.find(airports.flatten.uniq).pluck(:iso_region).uniq.count
  end

  def flight_search(identifier)
    locations = Location.where(
      Location.arel_table[:identifier].lower.matches("%#{identifier.downcase}%")
    ).pluck(:id)
    flight_results   = self.flights.where(from_id: locations).or(self.flights.where(to_id: locations))
    waypoint_results = Flight.find(self.waypoints.where(location_id: locations).pluck(:flight_id))
    search_results = flight_results + waypoint_results
    Kaminari.paginate_array(search_results.uniq.sort_by(&:flight_date).reverse)
  end
end
