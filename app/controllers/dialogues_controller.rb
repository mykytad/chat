class DialoguesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_dialogues

  def index
    @users = User.all
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

  def update
    @dialogue = Dialogue.find(params[:id])
    if @dialogue.pin_dialogue
      @dialogue.pin_dialogue = false
    else
      @dialogue.pin_dialogue = true
    end

    if @dialogue.save
      redirect_to dialogue_messages_path(@dialogue)
    end
  end

  def destroy
    @dialogue = Dialogue.find(params[:id])

    if current_user.id == @dialogue.sender_id || current_user.id == @dialogue.recipient_id
      @dialogue.destroy
      redirect_to dialogues_path
    end
  end

  def pin
    pinned_count = Dialogue.where(sender_id: current_user.id, pin_dialogue: true)
                           .or(Dialogue.where(recipient_id: current_user.id, pin_dialogue: true))
                           .count

    if pinned_count >= 10
      redirect_to dialogues_path, alert: 'You cannot pin more than 10 dialogues.'
    else
      @dialogue = Dialogue.find(params[:dialogue_id])
      @dialogue.update(pin_dialogue: true, pined_at: Time.now)

      if @dialogue.save
        redirect_to dialogue_messages_path(@dialogue), notice: 'Dialogue pinned successfully.'
      else
        redirect_to dialogues_path, alert: 'Failed to pin the dialogue.'
      end
    end
  end

  def unpin
    @dialogue = Dialogue.find(params[:dialogue_id])
    @dialogue.update(pin_dialogue: false, pined_at: nil)

    if @dialogue.save
      redirect_to dialogue_messages_path(@dialogue), notice: 'Dialogue unpinned successfully.'
    end
  end

  private

  def dialogue_params
    params.require(:dialogue).permit(:sender_id, :recipient_id)
  end

  def user_dialogues
    @dialogues = Dialogue.all.order(pin_dialogue: :DESC, :updated_at => :DESC)
    @user_dialogues = []
    @dialogues.each do |dialogue|
      if dialogue.sender_id == current_user.id || dialogue.recipient_id == current_user.id
        @user_dialogues << dialogue
      end
    end
  end
end
