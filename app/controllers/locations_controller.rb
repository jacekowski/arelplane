require 'csv'

class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.order(:identifier).page params[:page]
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    if params["location_db"]
      # locations = File.read(params["location_db"].tempfile)
      # csv = CSV.parse(locations, :headers => true)
      # csv.each do |row|
      #   l = Location.find(row.to_hash)
      #   if l.flight.count == 0
      #     if Location.where(identifier: l.identifier)
      #   end
      #   # Location.find_or_create_by(row.to_hash)
      # end
    else
      @location = Location.new(location_params)

      respond_to do |format|
        if @location.save
          format.html { redirect_to @location, notice: 'Location was successfully created.' }
          format.json { render :show, status: :created, location: @location }
        else
          format.html { render :new }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:identifier, :type, :name, :latitude, :longitude, :elevation, :continent, :iso_country, :iso_region, :municipality, :scheduled_service, :gps_code, :iata_code, :local_code, :home_link, :wikipedia_link, :keywords)
  end
end
