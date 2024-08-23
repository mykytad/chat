class MessagesController < ApplicationController
  before_action :dialogue
  before_action :user_dialogues
  before_action :recipient

  def index
    @dialogues = Dialogue.all.order(:updated_at => :DESC)
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
      @dialogue.update(last_message: @message.body, updated_at: Time.now)
      redirect_to dialogue_messages_path(@dialogue)
    else
      render :new, alert: 'Failed to send message.'
    end
  end

  def edit
    @message = dialogue.messages.find(params[:id])
  end

  def update
    @message = dialogue.messages.find(params[:id])
    if @message.update(message_params)
      redirect_to dialogue_messages_path(@dialogue)
    else
      render :edit, alert: 'Failed to update message.', notice: 'Message deleted successfully.'
    end
  end

  def destroy
    @message = dialogue.messages.find(params[:id])
    @message.destroy
    redirect_to dialogue_messages_path(@dialogue)
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :dialogue_id)
  end

  def dialogue
    @dialogue ||= Dialogue.find(params[:dialogue_id])
  end

  def user_dialogues
    @dialogues = Dialogue.all
    @user_dialogues = []
    @dialogues.each do |dialogue|
      if dialogue.sender_id == current_user.id || dialogue.recipient_id == current_user.id
        @user_dialogues << dialogue
      end
    end
  end

  def recipient
    @user_dialogues.each do |dialogue|
      if dialogue.sender_id == current_user.id
        @recipient = User.find(dialogue.recipient_id)
      else
        @recipient = User.find(dialogue.sender_id)
      end
    end
  end
end
