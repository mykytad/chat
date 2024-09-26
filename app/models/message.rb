class Message < ApplicationRecord
  belongs_to :user
  belongs_to :dialogue
  belongs_to :replied_to, class_name: 'Message', optional: true

  has_many :replies, class_name: 'Message', foreign_key: 'replied_to_id'
  has_many :notifications_mentions, as: :record, dependent: :destroy, class_name: "Noticed::Event"


  validates :body, presence: true
  validates :dialogue_id, presence: true
  validates :user_id, presence: true

  after_create_commit { broadcast_append_to self.dialogue }
end
