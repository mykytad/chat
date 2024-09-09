class Message < ApplicationRecord
  has_noticed_notifications

  belongs_to :user
  belongs_to :dialogue

  validates :body, presence: true
  validates :dialogue_id, presence: true
  validates :user_id, presence: true

  after_create_commit { broadcast_append_to self.dialogue }
  after_create_commit :notify_user

  def notify_user
    NewMessageNotifier.with(message: self).deliver_later(user)
  end
end
