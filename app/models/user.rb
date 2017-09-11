class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, on: :create

  has_many :flights

  def top_location
    Location.find(flights.pluck(:from_id, :to_id).flatten.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]).identifier
  end

  def top_region
    Location.find(flights.pluck(:from_id, :to_id).flatten.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]).iso_region
  end

  def top_aircraft
    flights.group(:aircraft_id).order('count_id DESC').limit(1).count(:id).keys.first
  end

  def total_flight_hours
    flights.pluck(:total_time).compact.sum.round(1)
  end

  def num_airports
    flights.pluck(:from_id, :to_id).flatten.uniq.count
  end

  def num_regions
    Location.find(flights.pluck(:from_id, :to_id).flatten.uniq).pluck(:iso_region).uniq.count
  end

end
