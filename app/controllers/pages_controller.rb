class PagesController < ApplicationController

  def index
    if user_signed_in?
      if current_user.username
        redirect_to username_path(current_user.username)
      else
        redirect_to user_path(current_user)
      end
    end
  end

end
