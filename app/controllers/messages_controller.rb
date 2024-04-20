class MessagesController < ApplicationController
  before_action :dialogue

  def index
    @dialogues = Dialogue.all
    @messages = @dialogue.messages
  end

  def new
    @message = dialogue.messages.new
  end

  def create
    @message = dialogue.messages.new(message_params)
    @message.dialogue_id = @dialogue.id
    @message.user_id = current_user.id

    if @message.save
      redirect_to dialogue_messages_path(@dialogue)
      # turbo_stream.prepend 'messages', partial: 'messages/message', locals: { message: @message }
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :dialogue_id)
  end

  def dialogue
    @dialogue ||= Dialogue.find(params[:dialogue_id])
  end
end
