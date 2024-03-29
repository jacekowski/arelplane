class Api::V1::LocationsController < ApiController
  before_action :set_location, only: :show

  def search
    query = Location.where("identifier like :q", q: "%#{params[:q]}%".upcase).
    or(Location.where("iata_code like :q", q: "%#{params[:q]}%".upcase))
    @locations = query.order('identifier').page(params[:page])

    respond_to do |format|
      format.json { render json: {total: query.count, locations: @locations.map { |location| {id: location.id, text: "#{location.identifier} (#{location.name})"} }} }
    end
  end

  def show
  end

private
  def set_location
    @location = Location.find(params[:id])
  end

end
