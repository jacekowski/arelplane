class WaypointsController < ApplicationController
  before_action :set_waypoint, only: :destroy

  def destroy
    if current_user == @waypoint.flight.user
      @waypoint.destroy
      respond_to do |format|
        format.html { redirect_to flights_url, notice: 'Waypoint was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

private
  def set_waypoint
    @waypoint = FlightWaypoint.find(params[:id])
  end

end