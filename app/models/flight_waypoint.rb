class FlightWaypoint < ApplicationRecord
  belongs_to :flight, inverse_of: :waypoints
  belongs_to :location
  default_scope { order(created_at: :asc) }

  after_destroy :update_map_cache

  after_commit do
    flight.add_distance
  end

  def update_map_cache
    user = self.flight.user
    CacheUserMapJob.perform_later(user)
    # GenerateHomepageMapJob.perform_later
    user.save_num_airports
    user.save_num_regions
  end
end
