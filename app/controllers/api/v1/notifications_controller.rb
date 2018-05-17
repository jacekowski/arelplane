class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notifications, only: [:index, :mark_as_read]

  def index
  end

  def mark_as_read
    @notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

private
  def set_notifications
    @notifications = Notification.where(recipient: current_user).unread
  end

end
