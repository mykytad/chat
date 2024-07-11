class PinDialogue < ApplicationRecord
  bilongs_to :dialogue
  bilongs_to :user
end
