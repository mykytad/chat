class DialoguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @dialoguess = Dialogue.all
  end

  def new
    @dialogue = Dialogue.new
  end

  def create
    @dialogue = Dialogue.create(dialogue_params)
    @dialogue.sender_id = current_user.id

    # @recipient_id = params[:recipient_id]

    if @dialogue.save
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  private

  def dialogue_params
    params.require(:dialogue).permit(:sender_id, :recipient_id)
  end
end
