class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :destroy]

  def show
  end

  def create
    @story = current_user.stories.new(story_params)
    @story.flights.each {|flight| flight.user_id = current_user.id}
    @story.user_ratings.each {|user_rating| user_rating.user_id = current_user.id}
    respond_to do |format|
      if @story.save
        add_subscription(@story)
        cache_map_data if @story.flights.any?
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.js
      else
        format.html { redirect_to root_path, alert: @story.errors.full_messages }
        format.js { render action: "failure"}
      end
    end
  end

  def destroy
    if current_user.id = @story.user_id
      @story.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Story was successfully destroyed.' }
        format.js   { render layout: false }
      end
    else
      flash[:notice] = "You are not authorized to delete that story"
      redirect_back
    end
  end

  def regenerate_map
    @story = Story.find(params[:story_id])
    CreateStoryImageJob.perform_later(@story)
    redirect_to root_path, notice: 'New map generating! It may take up to 10 minutes for the new image to appear'
  end

private
  def set_story
    @story = Story.find(params[:id])
  end

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
