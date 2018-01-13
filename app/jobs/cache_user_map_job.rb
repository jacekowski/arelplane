class CacheUserMapJob < ApplicationJob
  queue_as :default

  def perform(user)
    if user.cache_datum
      user.cache_datum.update_attributes(map_data: Flight.map_data(user.flights))
    else
      user.create_cache_datum(map_data: Flight.map_data(user.flights))
    end
  end
end
