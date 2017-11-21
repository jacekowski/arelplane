class RegistrationsController < Devise::RegistrationsController
  include Usernameable

  def create
    params["user"]["username"] = create_username(params["user"]["name"])
    super
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
      :current_password
    )
  end

end
