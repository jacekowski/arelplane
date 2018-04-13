require 'csv'

class FlightsController < ApplicationController
  before_action :set_flight, only: [:edit, :update, :destroy]
  after_action :update_cache, only: [:create, :update, :destroy]
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
        redirect_back
      elsif file = params["logtenpro"]
        Flight.parse_logtenpro(file.tempfile, current_user)
        redirect_back
      elsif file = params["mccpilotlog"]
        Flight.parse_mccpilotlog(file.tempfile, current_user)
        redirect_back
      elsif file = params["safelog"]
        Flight.parse_safelog(file.tempfile, current_user)
        redirect_back
      elsif file = params["zululog"]
        Flight.parse_zululog(file.tempfile, current_user)
        redirect_back
      elsif file = params["myflightbook"]
        Flight.parse_myflightbook(file.tempfile, current_user)
        redirect_back
      elsif file = params["logbookpro"]
        Flight.parse_logbookpro(file.tempfile, current_user)
        redirect_back
      elsif file = params["garminpilot"]
        Flight.parse_garmin_pilot(file.tempfile, current_user)
        redirect_back
      elsif file = params["flylogio"]
        Flight.parse_fly_logio(file.tempfile, current_user)
        redirect_back
      elsif file = params["pilotpro"]
        Flight.parse_pilot_pro(file.tempfile, current_user)
        redirect_back
      elsif file = params["aviationpilotlogbook"]
        Flight.parse_aviation_pilot_logbook(file.tempfile, current_user)
        redirect_back
      else
        @flight = current_user.flights.new(flight_params)
        set_aircraft_id(flight_params["aircraft_identifier"])
        if @flight.save
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
    byebug
  end

private
  def set_flight
    @flight = Flight.find(params[:id])
  end

  def set_aircraft_id(new_identifier)
    @flight.aircraft_id = Aircraft.find_or_create_by(identifier: new_identifier.try(:upcase)).id
  end

  def update_cache
    CacheUserMapJob.perform_later(current_user)
    # GenerateHomepageMapJob.perform_later
    current_user.save_total_flight_hours
    current_user.save_num_airports
    current_user.save_num_regions
  end

  def redirect_back
    redirect_to user_path(current_user.id)
  end

  def flight_params
    params.require(:flight).permit(
      :flight_date,
      :aircraft_identifier,
      :aircraft_id,
      :from_id,
      :to_id,
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
