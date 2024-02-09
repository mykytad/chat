class Dialogue < ApplicationRecord
  # belongs_to :sender_id, foreign_key: :sender_id, class_name: 'User'
  # belongs_to :recipient_id, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :recipient_id
end
