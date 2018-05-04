class StoriesController < ApplicationController

  def create
    @story = current_user.stories.new(story_params)
    @story.flights.each {|flight| flight.user_id = current_user.id}
    @story.user_ratings.each {|user_rating| user_rating.user_id = current_user.id}
    if @story.save
      redirect_to root_path, notice: 'Story was successfully created.'
    else
      redirect_to root_path, alert: @story.errors.full_messages
    end
  end

private
  def story_params
    params.require(:story).permit(
      :description,
      :rating_ids,
      flights_attributes: [
        :flight_date,
        :aircraft_identifier,
        :aircraft_id,
        :origin_id,
        :destination_id,
        :time_out,
        :time_in,
        :total_time,
        :pic,
        waypoints_attributes: [
          :location_id
        ]
      ]
    )
  end

end
