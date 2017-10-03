require 'csv'

class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]
  after_action :update_cache, only: [:create, :update, :destroy]
  before_action :authenticate_user!

  # GET /flights
  # GET /flights.json
  def index
    @flights = current_user.flights.order('flight_date DESC').page params[:page]
  end

  # GET /flights/1
  # GET /flights/1.json
  def show
  end

  # GET /flights/new
  def new
    @flight = current_user.flights.new
    @flight.waypoints.build
  end

  # GET /flights/1/edit
  def edit
    if current_user.id != @flight.user_id
      flash[:notice] = "You are not authorized to edit that flight"
      redirect_back
    end
    if @flight.waypoints.empty?
      @flight.waypoints.build
    end
  end

  # POST /flights
  # POST /flights.json
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
      else
        @flight = current_user.flights.new(flight_params)
        if @flight.save
          redirect_to root_path, notice: 'Flight was successfully created.'
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

  # PATCH/PUT /flights/1
  # PATCH/PUT /flights/1.json
  def update
    if current_user.id == @flight.user_id
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

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    if current_user.id = @flight.user_id
      @flight.destroy
      redirect_to flights_url, notice: 'Flight was successfully destroyed.'
    else
      flash[:notice] = "You are not authorized to delete that flight"
      redirect_back
    end
  end

private
  def set_flight
    @flight = Flight.find(params[:id])
  end

  def update_cache
    CacheUserMapJob.perform_later(current_user)
    # GenerateHomepageMapJob.perform_later
  end

  def redirect_back
    redirect_to user_path(current_user.id)
  end

  def flight_params
    params.require(:flight).permit(
      :flight_date,
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
