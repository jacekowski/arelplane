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

  has_many :passive_relationships, foreign_key: :following_id,
                                class_name: 'UserFollowing',
                                 dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_relationships, foreign_key: :follower_id,
                                   class_name: 'UserFollowing',
                                    dependent: :destroy
  has_many :following, through: :active_relationships, source: :following

  def follow_user(other_user)
    following << other_user
  end

  def unfollow_user(other_user)
    following.delete(other_user)
  end

  def following_user?(other_user)
    following.include?(other_user)
  end

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
    airport_count = 0
    if map_cache
      map_cache["features"].each do |f|
        if f["properties"]["feature_type"].try(:include?, "airport")
          airport_count += 1
        end
      end
    end
    airport_count
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

  def datetime_of_last_flight
    flights.last.created_at
  end

  def date_of_last_flight
    datetime_of_last_flight.to_date
  end

  def lastest_upload
    flights.where(created_at: date_of_last_flight.midnight..date_of_last_flight.end_of_day)
  end

  def self.most_flights
    left_joins(:flights).group(:id).order('COUNT(flights.id) DESC').limit(10)
  end

  def recent_updates
    flights.order('created_at::date DESC').group('created_at::date').limit(5).count
  end
end
