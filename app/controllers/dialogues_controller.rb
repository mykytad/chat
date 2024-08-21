class DialoguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @dialogues = Dialogue.all.order(:updated_at => :DESC)

    if params[:search].present?
      @users = @users.where("lower(nickname) like ?", "%#{params[:search].downcase}%")
    end
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

  def destroy
    @dialogue = Dialogue.find(params[:id])

    if current_user.id == @dialogue.sender_id || current_user.id == @dialogue.recipient_id
      @dialogue.destroy
      redirect_to dialogues_path
    end
  end

  private

  def dialogue_params
    params.require(:dialogue).permit(:sender_id, :recipient_id)
  end
end
