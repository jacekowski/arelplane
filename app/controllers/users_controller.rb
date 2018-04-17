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
    @feed = FeedPost.all.page(params[:page]).per(5)
    # @feed = NewsFeed.user_feed.page(params[:page]).per(5)
    @followers = current_user.followers
    @following = current_user.following
  end

  def unsubscribe
    subscription_preference = SubscriptionPreference.find_by(unsubscribe_token: params[:unsubscribe_token])
    if params[:unsubscribe_all]
      subscription_preference.update_attributes(no_emails: true)
      redirect_to unsubscribe_confirmation_path(type: 'all emails')
    else
      subscription_preference.update_attributes(new_follower_email: false)
      redirect_to unsubscribe_confirmation_path(type: 'new like emails')
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
