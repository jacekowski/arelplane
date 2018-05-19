class UserFollowingsController < ApplicationController
  def create
    @user = User.find(user_followings_params[:following_id])
    current_user.follow_user(@user)
    Notification.create(recipient: @user, actor: current_user, action:"followed", notifiable: current_user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = UserFollowing.find(params[:id]).following
    current_user.unfollow_user(@user)
    Notification.where(recipient: @user, actor: current_user, action:"followed", notifiable: current_user).destroy_all
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

private

  def user_followings_params
    params.require(:user_following).permit(
      :following_id,
      :follower_id
    )
  end
end
