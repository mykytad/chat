class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :dialogue
  before_action :user_dialogues

  def index
    @messages = @dialogue.messages
    @messages.where(read: false).where.not(user_id: current_user.id).update_all(read: true)
    @messages = @messages.order(created_at: :asc)
  end

  def create
    @message = @dialogue.messages.new(message_params)
    @message.user_id = current_user.id
    @message.replied_to_id = params[:message][:replied_to_id] if params[:message][:replied_to_id].present?

    if @message.save
      @dialogue.update(last_message: @message.body, updated_at: @message.created_at)
      redirect_to dialogue_messages_path(@dialogue)
    else
      flash[:alert] = 'Failed to send message.'
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  def update
    @message = @dialogue.messages.find(params[:id])

    if current_user.id == @message.user_id
      if @message.update(message_params)
        @dialogue.update(last_message: @message.body, updated_at: @message.created_at)
        redirect_to dialogue_messages_path(@dialogue)
      else
        redirect_to dialogue_messages_path(@dialogue), alert: 'Failed to update message.'
      end
    else
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  def destroy
    @message = dialogue.messages.find(params[:id])
    if @dialogue.sender_id == current_user.id || @dialogue.recipient_id == current_user.id
      @message.destroy
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :dialogue_id)
  end

  def dialogue
    @dialogue ||= Dialogue.find(params[:dialogue_id])
  end

  def user_dialogues
    @dialogues = Dialogue.all.order(pin_dialogue: :DESC, :updated_at => :DESC)
    @user_dialogues = Dialogue.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
                              .order(pin_dialogue: :desc, updated_at: :desc)
  end
end
