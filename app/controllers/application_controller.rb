class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_user_location!, if: :storable_location?
  before_action :set_notifications, if: :user_signed_in?

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def cache_map_data
    CacheUserMapJob.perform_later(current_user)
    current_user.save_total_flight_hours
    current_user.save_num_airports
    current_user.save_num_regions
  end

  def set_notifications
    @notifications = Notification.where(recipient: current_user).recent
  end

private
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
