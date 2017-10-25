class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
      # Path you want to redirect the user to after login.
      users_path(current_user)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
