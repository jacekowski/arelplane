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
  end

  # GET /flights/1/edit
  def edit
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
      else
        @flight = current_user.flights.new(flight_params)
        respond_to do |format|
          if @flight.save
            format.html { redirect_to root_path, notice: 'Flight was successfully created.' }
            format.json { render :show, status: :created, location: @flight }
          else
            format.html { render :new }
            format.json { render json: @flight.errors, status: :unprocessable_entity }
          end
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
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to root_path, notice: 'Flight was successfully updated.' }
        format.json { render :show, status: :ok, location: @flight }
      else
        format.html { render :edit }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    @flight.destroy
    respond_to do |format|
      format.html { redirect_to flights_url, notice: 'Flight was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def flight_params
      params.require(:flight).permit(:flight_date, :aircraft_id, :from_id, :to_id, :time_out, :time_in, :total_time, :pic, :distance)
    end
end
