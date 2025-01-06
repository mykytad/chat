class Message < ApplicationRecord
  belongs_to :user
  belongs_to :dialogue
  belongs_to :replied_to, class_name: 'Message', optional: true

  has_many :replies, class_name: 'Message', foreign_key: 'replied_to_id'

  validates :body, presence: true
  validates :dialogue_id, presence: true
  validates :user_id, presence: true

  scope :unread_by, ->(user) { where(read: false).where.not(user_id: user.id) }

  after_create_commit { broadcast_append_to "dialogue_#{dialogue.id}_messages" }
  after_update_commit { broadcast_replace_to "dialogue_#{dialogue.id}_messages" }
  after_destroy_commit { broadcast_remove_to "dialogue_#{dialogue.id}_messages" }

  private

  # add back-shielding to the model before saving
  def escape_html
    self.body = CGI.escapeHTML(self.body)
  end
end
