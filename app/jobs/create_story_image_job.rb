class CreateStoryImageJob < ApplicationJob
  queue_as :default

  def perform(story)
    res = RestClient.post(
      'https://arelplane-map-snap.herokuapp.com/1?auth=ba324d902dcff2bd5688d040163a82bb',
      {
        content_type: :json,
              accept: :json
      }
    )
    image_url = JSON.parse(res.body)["response"]["image_url"]
    story.update_attributes(map_image_url: image_url)
  end
end

# ENV['MAP_SNAP_API_KEY']
