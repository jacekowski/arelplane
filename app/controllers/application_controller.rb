class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
      "/users/#{current_user.id}" # <- Path you want to redirect the user to after login.
  end
end
