class DialogueChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"

    # Find the dialogue based on the dialogue_id parameter
    # dialogue = Dialogue.find(params[:id])
    # messages = dialogue.messages
    # Stream for the found dialogue
    # stream_for messages
    # rescue ActiveRecord::RecordNotFound
    # If the chat is not found, reject the subscription
    # reject
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
