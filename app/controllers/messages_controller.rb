class MessagesController < ApplicationController
  before_action :dialogue
  before_action :user_dialogues

  def index
    @messages = @dialogue.messages
    @messages.where(read: false).where.not(user_id: current_user.id).update_all(read: true)
  end

  def create
    @message = @dialogue.messages.new(message_params)
    @message.user_id = current_user.id
    @message.replied_to_id = params[:message][:replied_to_id] if params[:message][:replied_to_id].present?

    if @message.save
      @dialogue.update(last_message: @message.body, updated_at: Time.now)
      redirect_to dialogue_messages_path(@dialogue)
    else
      flash[:alert] = 'Failed to send message.'
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  def update
    @message = dialogue.messages.find(params[:id])
    if @message.update(message_params)
      redirect_to dialogue_messages_path(@dialogue), notice: 'Message updated successfully.'
    else
      redirect_to dialogue_messages_path(@dialogue), alert: 'Failed to update message.'
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
    @dialogues = Dialogue.all.order(pin_dialogue: :DESC, pined_at: :DESC, :updated_at => :DESC)
    @user_dialogues = []
    @dialogues.each do |dialogue|
      if dialogue.sender_id == current_user.id || dialogue.recipient_id == current_user.id
        @user_dialogues << dialogue
      end
    end
  end
end
