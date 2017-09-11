class Api::V1::FlightsController < ApiController

  def index
    if user_id = params[:user_id]
      @flights = Flight.map_data(User.find(user_id).flights)
    else
      @flights = CacheDatum.last
    end
  end

end
