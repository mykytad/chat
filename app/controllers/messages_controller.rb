class MessagesController < ApplicationController
  before_action do
    @dialogue = Dialogue.find(params[:dialogue_id])
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
