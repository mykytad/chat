class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.includes(event: :record)
    @last_notification = @notifications.last
    @last_notification = @last_notification.message
  end
end
