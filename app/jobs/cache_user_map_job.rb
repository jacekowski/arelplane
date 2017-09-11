class CacheUserMapJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update(map_cache: Flight.map_data(user.flights))
  end
end
