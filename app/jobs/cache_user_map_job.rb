class CacheUserMapJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.cache_datum.update(map_data: Flight.map_data(user.flights))
  end
end
