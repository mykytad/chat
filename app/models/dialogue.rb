class Dialogue < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :recipient_id

  after_update_commit { broadcast_replace_to "dialogues" }

  scope :between, ->(sender_id, recipient_id) do
    where("(dialogues.sender_id = ? AND dialogues.recipient_id =?) OR
    (dialogues.sender_id = ? AND dialogues.recipient_id =?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  def unread_messages_count_for(user_id)
    messages.where(read: false).where.not(user_id: user_id).count
  end
end
