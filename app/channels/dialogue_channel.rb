class DialogueChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"

    # Find the chat based on the chat_id parameter
    dialogue = Dialogue.find(params[:id])
    # Stream for the found chat
    stream_for dialogue
    rescue ActiveRecord::RecordNotFound
    # If the chat is not found, reject the subscription
    reject
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
