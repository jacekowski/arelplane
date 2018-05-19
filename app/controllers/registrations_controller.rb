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
      Notification.create(recipient: @user, actor: User.find(64), action:"notified", notifiable: User.find(64))
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
      :employer,
      rating_ids: []
    )
  end

protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

end
