class Dialogue < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :recipient_id

  scope :between, ->(sender_id, recipient_id) do
    where("(dialogues.sender_id = ? AND dialogues.recipient_id =?) OR
    (dialogues.sender_id = ? AND dialogues.recipient_id =?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  # def last_message
  #   self.messages.last.body
  #   save
  # end

  # after_update do
  #   last_message
  # end
end
