class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, on: :create

  has_many :flights

  def flight_metrics
    metrics = {}
    top_location = Hash.new(0)
    regions = []
    aircraft = Hash.new(0)
    num_locations = []
    flights.all.each do |flight|
      top_location[flight.to] += 1
      top_location[flight.from] += 1
      regions << flight.to.iso_region
      regions << flight.from.iso_region
      aircraft[flight.aircraft_id] += 1
      num_locations << flight.to
      num_locations << flight.from
    end
    metrics[:top_location] = top_location.key(top_location.values.max)
    metrics[:num_regions] = regions.uniq.count
    metrics[:top_aircraft] = aircraft.key(aircraft.values.max)
    metrics[:num_locations] = num_locations.uniq.count
    metrics
  end

  def total_flight_hours
    flights.pluck(:total_time).compact.sum.round(1)
  end

end
