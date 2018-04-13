class Api::V1::UsersController < ApiController
  before_action :set_user, only: :show

  def search
    query = User.where("username like :q", q: "%#{params[:q]}%")
    @users = query.order('username').page(params[:page])

    respond_to do |format|
      format.json { render json: {total: query.count, users: @users.map { |user| {id: user.id, text: user.username} }} }
    end
  end

  def show
  end

  private
    def set_user
      @user = User.find_by(username: params[:username])
    end

end
