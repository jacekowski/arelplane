class Stories::CommentsController < CommentsController
  before_action :set_commentable

private
  def set_commentable
    @commentable = Story.find(params[:story_id])
  end
end
