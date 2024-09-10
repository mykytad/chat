# To deliver this notification:
#
# NewMessageNotificationNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotificationNotifier < ApplicationNotifier
  # Add your delivery methods
  deliver_by :database

  # Define required params
  param :message

  # Define how the message will be displayed
  def message
    "New message from #{params[:message].user.name}: #{params[:message].body}"
  end

  # Provide the URL for the notification link
  def url
    dialogue_path(params[:message].dialogue)
  end
end
