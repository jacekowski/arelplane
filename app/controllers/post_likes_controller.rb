class PostLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feed_post

  def create
    @feed_post.likes.where(user_id: current_user.id).first_or_create
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def destroy
    @feed_post.likes.where(user_id: current_user.id).destroy_all
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def set_feed_post
    @feed_post = FeedPost.find(params[:feed_post_id])
  end

end
