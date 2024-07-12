class PinDialogueController < ApplicationController
  def create
    @pin_dialogue = PinDialogue.new
    @pin_dialogue.user_id = current_user.id
    @pin_dialogue.dialogue_id = params[:dialogue_id]
    @pin_dialogue.save
  end
end
