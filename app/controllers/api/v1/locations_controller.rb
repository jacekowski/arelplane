class Api::V1::LocationsController < ApiController

  def search_by_identifier
    query = Location.where("identifier like :q", q: "%#{params[:q]}%".upcase)
    @locations = query.order('identifier').page(params[:page])

    respond_to do |format|
      format.json { render json: {total: query.count, locations: @locations.map { |location| {id: location.id, text: "#{location.identifier} (#{location.name})"} }} }
    end
  end

end
