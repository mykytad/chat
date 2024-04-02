class Message < ApplicationRecord
  belongs_to :user
  belongs_to :dialogue

  validates :body, presence: true
  validates :dialogue_id, presence: true
  validates :user_id, presence: true

  # after_create_commit { broadcast_prepend_to "messages", partial: "messages/new", locals: { messages: self }, target: "messages" }
end
