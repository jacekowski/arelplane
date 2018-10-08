class NewsFeedController < ApplicationController

  def index
    @stories = Story.all.page(params[:page]).per(5)
    respond_to do |format|
      format.js { render file: '/users/stories', locals: {type: 'main-feed'} }
    end
  end

end
