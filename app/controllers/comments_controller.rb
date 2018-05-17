class CommentsController < ApplicationController

  def create
    respond_to do |format|
      if current_user
        @comment = @commentable.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
          (@commentable.commenters + [@commentable.user] - [current_user]).uniq.each do |commenter|
            Notification.create(recipient: commenter, actor: current_user, action:"posted", notifiable: @comment)
          end
          @commentable.add_subscription(current_user)
          send_email
          format.html { redirect_to root_path}
          format.js
        else
          format.html { redirect_to root_path, alert: @comment.errors.full_messages }
          format.js { render action: "failure"}
        end
      else
        session[:form_data] = params["comment"]["body"]
        format.js { render action: 'register'}
      end
    end
  end

private
  def send_email
    @commentable.subscribers.each do |subscriber|
      if @comment.user != subscriber
        if @commentable.user == subscriber
          StoryMailer.new_comment(@comment).deliver_later
        else
          StoryMailer.following_story_comment(@comment, subscriber).deliver_later
        end
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
