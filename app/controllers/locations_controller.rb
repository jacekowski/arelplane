class LocationsController < ApplicationController
  before_action :set_paper_trail_whodunnit
  before_action :set_location, only: [:show, :edit, :destroy, :select_version, :destroy_version]
  before_action :set_version, only: [:select_version, :destroy_version]

  # When a location is updated, if Admin - Update
  #  else mark as pending then rollback to previous version
  #   Send an email to admin to approve or disapprove
  # Probably need to build some kind of admin view to see and approve/disapprove changes

  def index
    @locations = Location.order(:identifier).page params[:page]
  end

  def show
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
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

  def update
    @location = Location.find(params[:identifier]) # Actually the ID
    respond_to do |format|
      if @location.update(location_params)
        @location.rollback_unless_authorized(current_user)
        format.html { redirect_to location_path(@location.identifier), notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location.identifier }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_version
    @version.destroy
    respond_to do |format|
      format.html { redirect_to location_path(@location.identifier), notice: 'Version was successfully destroyed.' }
      format.js   { render layout: false }
    end
  end

  def select_version
    PaperTrail.request.enabled = false
    respond_to do |format|
      if @location.update(@version.reify.attributes)
        @version.destroy
        format.html { redirect_to location_path(@location.identifier), notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location.identifier }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
    PaperTrail.request.enabled = true
  end

private
  def set_location
    @location = Location.find_by(identifier: params[:identifier].upcase) or not_found
  end

  def set_version
    @version = @location.versions.find(params[:version])
  end

  def location_params
    params.require(:location).permit(:identifier, :type, :name, :latitude, :longitude, :elevation, :continent, :iso_country, :iso_region, :municipality, :scheduled_service, :gps_code, :iata_code, :local_code, :home_link, :wikipedia_link, :keywords)
  end
end
