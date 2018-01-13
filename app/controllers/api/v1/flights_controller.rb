class Api::V1::FlightsController < ApiController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]

  def index
    if user_id = params[:user_id]
      user = User.find(user_id)
      if cache = user.cache_datum.try(:map_data)
        @flights = cache
      else
        @flights = Flight.map_data(user.flights)
        CacheUserMapJob.perform_later(user)
      end
    else
      arel = User.find_by(email: 'arelenglish@gmail.com')
      @flights = arel.cache_datum.map_data
      # Use Arel's map becaue the agregate map looks cluttered
      # @flights = CacheDatum.last.map_data
    end
  end

  def show
  end

private
  def set_flight
    @flight = Flight.find(params[:id])
  end

end
