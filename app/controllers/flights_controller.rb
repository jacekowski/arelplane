require 'csv'

class FlightsController < ApplicationController
  before_action :set_flight, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @flights = current_user.flights.order('created_at DESC').page params[:page]
  end

  def search
    @flights = current_user.flight_search(params[:query]).page params[:page]
    render :index
  end

  def new
    @flight = current_user.flights.new
    @flight.waypoints.build
  end

  def edit
    if current_user.id != @flight.user_id
      flash[:notice] = "You are not authorized to edit that flight"
      redirect_back
    end
    if @flight.waypoints.empty?
      @flight.waypoints.build
    end
  end

  def create
    begin
      if file = params["foreflight"]
        Flight.parse_foreflight(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["logtenpro"]
        Flight.parse_logtenpro(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["mccpilotlog"]
        Flight.parse_mccpilotlog(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["safelog"]
        Flight.parse_safelog(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["zululog"]
        Flight.parse_zululog(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["myflightbook"]
        Flight.parse_myflightbook(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["logbookpro"]
        Flight.parse_logbookpro(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["garminpilot"]
        Flight.parse_garmin_pilot(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["flylogio"]
        Flight.parse_fly_logio(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["pilotpro"]
        Flight.parse_pilot_pro(file.tempfile, current_user)
        cache_map_data
        redirect_back
      elsif file = params["aviationpilotlogbook"]
        Flight.parse_aviation_pilot_logbook(file.tempfile, current_user)
        cache_map_data
        redirect_back
      else
        @flight = current_user.flights.new(flight_params)
        set_aircraft_id(flight_params["aircraft_identifier"])
        if @flight.save
          cache_map_data
          redirect_to new_flight_path, notice: 'Flight was successfully created.'
        else
          render :new
        end
      end
    rescue
      unless params[:flight]
        UploadErrorMailer.error(current_user, file).deliver
      end
      raise
    end
  end

  def update
    if current_user.id == @flight.user_id
      set_aircraft_id(flight_params["aircraft_identifier"])
      if @flight.update(flight_params)
        cache_map_data
        redirect_to flights_path, notice: 'Flight was successfully updated.'
      else
        render :edit
      end
    else
      flash[:notice] = "You are not authorized to update that flight"
      redirect_back
    end
  end

  def destroy
    if current_user.id = @flight.user_id
      @flight.destroy
      cache_map_data
      respond_to do |format|
        format.html { redirect_to flights_url, notice: 'Flight was successfully destroyed.' }
        format.js   { render layout: false }
      end
    else
      flash[:notice] = "You are not authorized to delete that flight"
      redirect_back
    end
  end

  def destroy_multiple
    if params[:flights] == 'all'
      current_user.flights.destroy_all
      redirect_to flights_url, notice: 'All your flights have been deleted.'
    elsif params[:flights] == 'broken'
      Flight.flights_with_missing_identifiers_for(current_user).each(&:destroy)
      redirect_to flights_url, notice: 'All flights with missing identifiers have been deleted.'
    end
    cache_map_data
  end

private
  def set_flight
    @flight = Flight.find(params[:id])
  end

  def set_aircraft_id(new_identifier)
    @flight.aircraft_id = Aircraft.find_or_create_by(identifier: new_identifier.try(:upcase)).id
  end

  def redirect_back
    redirect_to user_path(current_user.id)
  end

  def flight_params
    params.require(:flight).permit(
      :flight_date,
      :aircraft_identifier,
      :aircraft_id,
      :origin_id,
      :destination_id,
      :time_out,
      :time_in,
      :total_time,
      :pic,
      :distance,
      waypoints_attributes: [
        :location_id,
        :id
      ]
    )
    end
end
