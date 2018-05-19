class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    if Notification.where(recipient: current_user).unread.count < 5
      @notifications = Notification.where(recipient: current_user).recent
    else
      @notifications = Notification.where(recipient: current_user).unread
    end
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

private

end
