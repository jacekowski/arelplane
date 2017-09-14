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
      arel = User.find_by(email: 'arelenglish@gmail.com')
      @flights = Flight.map_data(arel.flights)
      # Use Arel's map becaue the agregate map looks cluttered
      # @flights = CacheDatum.last.map_data
    end
  end

end
