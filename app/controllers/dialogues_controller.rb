class DialoguesController < ApplicationController
  before_action :authenticate_user!

  def index
    if :authenticate_user!
      @users = User.all
      @dialogues = Dialogue.all
    else
      redirect_to new_user_session_path
    end
  end

  def new
    @dialogue = Dialogue.new
  end

  def create
    @dialogue = Dialogue.new
    @dialogue.sender_id = current_user.id
    @dialogue.recipient_id = params[:recipient_id]
    @dialogue.save

    if @dialogue.save
      redirect_to dialogue_messages_path(@dialogue)
    else
      redirect_to dialogues_path, alert: "some went wrong"
    end
  end

  private

  def dialogue_params
    params.require(:dialogue).permit(:sender_id, :recipient_id)
  end
end
