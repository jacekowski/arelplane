class RegistrationsController < Devise::RegistrationsController
  include Usernameable

  def create
    if params["user"]["username"]
      params["user"]["username"] = create_username(params["user"]["username"])
    else
      params["user"]["username"] = create_username(params["user"]["name"])
    end
    super
    if @user.persisted?
      UserMailer.welcome_email(@user).deliver_later
    end
   end

   def update
    params["user"]["username"] = create_username(params["user"]["username"])
    super
   end

private
  def sign_up_params
    params.require(:user).permit(
      :name,
      :email,
      :username,
      :instagram,
      :password,
      :password_confirmation
    )
  end

  def account_update_params
    params.require(:user).permit(
      :name,
      :email,
      :username,
      :instagram,
      :password,
      :password_confirmation,
      :current_password,
      :home_base_id,
      :bio,
      rating_ids: []
    )
  end

end
