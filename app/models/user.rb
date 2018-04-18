class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validates :name,     presence: true, on: :create
  validates :username, presence: true,
                     uniqueness: {case_sensitive: false},
                         length: { maximum: 100 }
  validates :bio,        length: { maximum: 250 }
  validates :employer,   length: { maximum: 50 }

  has_one  :cache_datum, dependent: :destroy
  has_many :flights,     dependent: :destroy
  has_many :locations,     through: :flights
  has_many :waypoints,     through: :flights

  belongs_to :home_base, class_name: 'Location', foreign_key: :home_base_id, optional: true

  has_many :passive_relationships, foreign_key: :following_id,
                                    class_name: 'UserFollowing',
                                     dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_relationships, foreign_key: :follower_id,
                                   class_name: 'UserFollowing',
                                    dependent: :destroy
  has_many :following, through: :active_relationships, source: :following

  has_one :subscription_preference
  before_create :add_subscription_preferences

  has_many :user_ratings
  has_many :ratings, through: :user_ratings, dependent: :destroy

  has_many :feed_posts, dependent: :destroy

  def add_subscription_preferences
    build_subscription_preference(unsubscribe_token: SecureRandom.hex)
  end

  def follow_user(followed_user)
    following << followed_user
    if followed_user.subscription_preference.new_follower_email &&
      !followed_user.subscription_preference.no_emails
      UserMailer.new_follower(self, followed_user).deliver_later
    end
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
    flights.pluck(:origin_id, :destination_id).flatten
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
    if aircraft = flights.group(:aircraft_id).order('count_id DESC').limit(1).count(:id).keys.first
      Aircraft.find(aircraft)
    end
  end

  def total_flight_hours
    total_flight_hours_cache&.nonzero? ||
    save_total_flight_hours
  end

  def save_total_flight_hours
    update_attributes(
      total_flight_hours_cache: flights.pluck(:total_time).compact.sum.round(1)
    )
    total_flight_hours_cache
  end

  def num_airports
    num_airports_cache&.nonzero? ||
    save_num_airports
  end

  def save_num_airports
    airports = flights.pluck(:origin_id, :destination_id)
    waypoints.each do |wp|
      if wp.location.location_type.try(:include?, "airport")
        airports << wp.location.id
      end
    end
    update_attributes(
      num_airports_cache: airports.flatten.uniq.count
    )
    num_airports_cache
  end

  def num_regions
    num_regions_cache&.nonzero? ||
    save_num_regions
  end

  def save_num_regions
    update_attributes(
      num_regions_cache: Location.find(locations.uniq).pluck(:iso_region).uniq.count
    )
    num_regions_cache
  end

  def flight_search(identifier)
    locations = Location.where(
      Location.arel_table[:identifier].lower.matches("%#{identifier.try(:downcase)}%")
    ).pluck(:id)
    flight_results   = self.flights.where(origin_id: locations).or(self.flights.where(destination_id: locations))
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
    order("users.flights_count DESC").limit(10)
  end

  def total_distance
    flights.pluck(:distance).compact.sum.round(1)
  end

  def recent_updates
    flights.order('created_at::date DESC').group('created_at::date').limit(5).count
  end
end
