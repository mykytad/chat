class MessagesController < ApplicationController
  before_action do
    @dialogue = Dialogue.find(params[:dialogue_id])
  end

  def index
    @messages = @dialogue.messages
  end

  def new
    @message = @dialogue.messages.new
  end

  def create
    @message = @dialogue.messages.new(message_params)
    if @message.save
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :dialogue_id)
  end
end
