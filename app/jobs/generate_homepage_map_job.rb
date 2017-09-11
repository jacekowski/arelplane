class GenerateHomepageMapJob < ApplicationJob
  queue_as :default

  def perform
    cache = CacheDatum.create(map_data: Flight.map_data(Flight))
    CacheDatum.where.not(id: cache.id).destroy_all
  end
end
