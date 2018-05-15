class CommentsController < ApplicationController

  def create
    @comment = @commentable.comments.new(comment_params)
    respond_to do |format|
      if current_user
        @comment.user = current_user
        @comment.save
        if @comment.save
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
  def comment_params
    params.require(:comment).permit(:body)
  end
end
