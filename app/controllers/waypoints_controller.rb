class WaypointsController < ApplicationController
  before_action :set_waypoint, only: :destroy

  def destroy
    if current_user == @waypoint.flight.user
      @waypoint.destroy
      cache_map_data
      respond_to do |format|
        format.html { redirect_to flights_url, notice: 'Waypoint was successfully destroyed.' }
        format.js   { render :layout => false }
      end
    end
  end

private
  def cache_map_data
    CacheUserMapJob.perform_later(current_user)
    # GenerateHomepageMapJob.perform_later
    current_user.save_total_flight_hours
    current_user.save_num_airports
    current_user.save_num_regions
  end

  def set_waypoint
    @waypoint = FlightWaypoint.find(params[:id])
  end

end
