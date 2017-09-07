require 'csv'

class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /flights
  # GET /flights.json
  def index
    @flights = current_user.flights.all
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
    if params["foreflight"]
      Flight.parse_foreflight(params["foreflight"].tempfile, current_user)
      redirect_to user_path(current_user.id)
    elsif params["logtenpro"]
      Flight.parse_logtenpro(params["logtenpro"].tempfile, current_user)
      redirect_to user_path(current_user.id)
    else
      # @flight = current_user.flights.new(flight_params)
      # respond_to do |format|
      #   if @flight.save
      #     format.html { redirect_to @flight, notice: 'Flight was successfully created.' }
      #     format.json { render :show, status: :created, location: @flight }
      #   else
      #     format.html { render :new }
      #     format.json { render json: @flight.errors, status: :unprocessable_entity }
      #   end
      # end
    end
  end

  # PATCH/PUT /flights/1
  # PATCH/PUT /flights/1.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to @flight, notice: 'Flight was successfully updated.' }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def flight_params
      params.require(:flight).permit(:flight_date, :aircraft_id, :from_id, :to_id, :time_out, :time_in, :total_time, :pic, :distance)
    end
end
