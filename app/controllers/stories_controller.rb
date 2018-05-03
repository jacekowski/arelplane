class StoriesController < ApplicationController

  def create
    @story = current_user.stories.new(story_params)
    @story.flights.each {|flight| flight.user_id = current_user.id}
    if @story.save
      redirect_to root_path, notice: 'Story was successfully created.'
    else
      redirect_to root_path, flash: { error: @story.errors }
    end
  end

private
  def story_params
    params.require(:story).permit(
      :description,
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
          :location_id,
          :id
        ]
      ]
    )
  end

end
