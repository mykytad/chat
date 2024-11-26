class DialogueChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_user
  end

  def unsubscribed
  end
end
