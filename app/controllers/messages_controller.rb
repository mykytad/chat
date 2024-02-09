class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
  end

  private

  def message_params
    params.require(:review).permit(:body)
  end
end
