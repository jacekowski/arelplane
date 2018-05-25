class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    if user_id = params[:id]
      if username = User.find(user_id).username
        redirect_to username_path(username)
      end
    end
  end

  def search
    redirect_to username_path(User.find(params[:user_id]).username)
  end

  def home
    @user = current_user
    @stories = Kaminari.paginate_array(Story.smart_feed).page(params[:page]).per(5)
    @followers = current_user.followers
    @following = current_user.following

    @story = current_user.stories.new
    flight = @story.flights.build
    flight.waypoints.build
    respond_to do |format|
      format.html
      format.js { render action: 'stories', locals: {type: 'main-feed'} }
    end
  end

  def followers
    @stories = Story.includes(:flights, :ratings).where(user: current_user.followers).page(params[:page]).per(10)
    respond_to do |format|
      format.js { render action: 'stories', locals: {type: 'followers-feed'} }
    end
  end

  def following
    @stories = Story.includes(:flights, :ratings).where(user: current_user.following).page(params[:page]).per(10)
    respond_to do |format|
      format.js { render action: 'stories', locals: {type: 'following-feed'} }
    end
  end

  def stories
    @stories = current_user.stories.page(params[:page]).per(10)
    respond_to do |format|
      format.js { render action: 'stories', locals: {type: 'personal-feed'} }
    end
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
      params.require(:user).permit(
        :email,
        :name,
        :unsubscribe_all
      )
    end
end
