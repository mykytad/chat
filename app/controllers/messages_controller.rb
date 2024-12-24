class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :dialogue
  before_action :user_dialogues

  def index
    @messages = @dialogue.messages
    # @messages.where(read: false).where.not(user_id: current_user.id).update_all(read: true)
    # @messages.unread_by(current_user).each { |message| message.update(read: true) }
    @messages = @messages.order(created_at: :asc)
    @current_user_id = current_user.id

    if params[:replied_to_id].present?
      @replied_message = @messages.find(params[:replied_to_id])
      @replied_message = @replied_message.body
    end
  end

  def create
    if current_user.id == @dialogue.sender_id || current_user.id == @dialogue.recipient_id
      @message = @dialogue.messages.new(message_params)
      @message.user_id = current_user.id
      @message.replied_to_id = params[:message][:replied_to_id] if params[:message][:replied_to_id].present?
      @message.created_at = Time.now.strftime("%c")
      @message.updated_at = Time.now.strftime("%c")
      @message.edited_at = Time.now.strftime("%c")

      if @message.save
        @dialogue.update(last_message: @message.body, updated_at: @message.created_at)
        redirect_to dialogue_messages_path(@dialogue)
      else
        flash[:alert] = 'Failed to send message.'
        redirect_to dialogue_messages_path(@dialogue)
      end
    else
      redirect_to dialogues_path
    end
  end

  def update
    @message = @dialogue.messages.find(params[:id])

    if current_user.id == @message.user_id
      if @message.update(message_params)
        if @message.save
          @message.update(edited_at: Time.now.strftime("%c"), updated_at: Time.now.strftime("%c"))
          @message.updated_at = Time.now.strftime("%c")
        end

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
    else
      redirect_to dialogues_path, alert: "you can't delete this message"
    end
  end

  def read
    @message = Message.find(params[:id])
    @messages = @dialogue.messages
    @messages.unread_by(current_user).each { |message| message.update(read: true) }
    @dialogue.touch
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :dialogue_id)
  end

  def dialogue
    @dialogue ||= Dialogue.find(params[:dialogue_id])
  end

  def user_dialogues
    @dialogues = Dialogue.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
                              .order(pin_dialogue: :desc, pined_at: :desc, updated_at: :desc)
  end
end
