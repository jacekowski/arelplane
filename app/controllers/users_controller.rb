class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  private
    def set_user
      if params[:username]
        @user = User.find_by(username: params[:username]) or not_found
      else
        @user = User.find(params[:id])
      end
    end

    def user_params
      params.require(:user).permit(:email, :name)
    end
end
