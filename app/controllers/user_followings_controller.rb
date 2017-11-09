class UserFollowingsController < ApplicationController
  def create
    @user = User.find(user_followings_params[:following_id])
    current_user.follow_user(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = UserFollowing.find(params[:id]).following
    current_user.unfollow_user(@user)
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
