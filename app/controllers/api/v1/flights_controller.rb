class Api::V1::FlightsController < ApiController

  def index
    if user_id = params[:user_id]
      user = User.find(user_id)
      if cache = user.map_cache
        @flights = cache
      else
        @flights = Flight.map_data(user.flights)
      end
    else
      @flights = CacheDatum.last.map_data
    end
  end

end
