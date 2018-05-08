require 'rest-client'

class CreateStoryImageJob < ApplicationJob
  queue_as :default

  def perform(story)
    res = RestClient.post("#{ENV['MAPSNAP_ROOT_URL']}/story/#{story.id}?auth=#{ENV['MAP_SNAP_API_KEY']}",{content_type: :json,accept: :json})
    image_url = JSON.parse(res.body)["response"]["image_url"]
    story.update_attributes(map_image_url: image_url)
  end
end

# ENV['MAP_SNAP_API_KEY']
