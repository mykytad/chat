class NotifiersController < ApplicationController
  def index
      @notifier = Notifier.where(recipient: current_user)
  end
end
