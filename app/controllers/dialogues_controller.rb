class DialoguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @dialogue = Dialogue.all
  end

  def create
    @dialogue = Dialogue.create(dialogue_params)
    @dialogue.sender_id = current_user.id
    # @dialogue.recipient_id = 
  end

  private

  def dialogue_params
    params.require(:dialogue).permit(:sender_id, :recipient_id)
  end
end
