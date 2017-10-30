class Api::V1::UsersController < ApiController

  def search_by_username
    query = User.where("username like :q", q: "%#{params[:q]}%")
    @users = query.order('username').page(params[:page])

    respond_to do |format|
      format.json { render json: {total: query.count, users: @users.map { |user| {id: user.id, text: user.username} }} }
    end
  end

end