class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.includes(event: :record)
  end
end
