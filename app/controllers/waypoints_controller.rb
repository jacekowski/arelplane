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
  def set_waypoint
    @waypoint = FlightWaypoint.find(params[:id])
  end

end
