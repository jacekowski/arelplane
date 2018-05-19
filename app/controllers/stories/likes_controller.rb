class Stories::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story

  def create
    @story.likes.where(user_id: current_user.id).first_or_create
    Notification.create(recipient: @story.user, actor: current_user, action:"liked", notifiable: @story)
    send_email
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def destroy
    @story.likes.where(user_id: current_user.id).destroy_all
    Notification.where(recipient: @story.user, actor: current_user, action:"liked", notifiable: @story).destroy_all
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

private
  def send_email
    if current_user != @story.user && @story.subscribers.include?(@story.user)
      StoryMailer.new_like(current_user, @story).deliver_later
    end
  end

  def set_story
    @story = Story.find(params[:story_id])
  end

end
