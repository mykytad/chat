class Message < ApplicationRecord
  belongs_to :user
  belongs_to :dialogue
  belongs_to :replied_to, class_name: "Message", optional: true

  has_many :replies, class_name: "Message", foreign_key: "replied_to_id"

  mount_uploaders :images, ImageUploader
  serialize :images # , JSON  If you use SQLite,

  # validates :body, presence: true
  validate :body_or_image_present
  validate :message_images_limit
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

  # extract link preview data
  def fetch_link_preview
    Rails.logger.debug "Fetching link preview for: #{body}"
    return unless body =~ URI::DEFAULT_PARSER.make_regexp

    preview_data = LinkPreviewService.fetch(body.match(URI::DEFAULT_PARSER.make_regexp)[0])
    Rails.logger.debug "Preview data: #{preview_data.inspect}"

    if preview_data
      self.link_title = preview_data[:title]
      self.link_description = preview_data[:description]
      self.link_image = preview_data[:image]
      self.link_url = preview_data[:url]
    end
  end

  def body_or_image_present
    if body.blank? && images.blank?
      errors.add(:base, "The message must contain text or at least one image")
    end
  end

  # limit for images in a message
  def message_images_limit
    if images.count > 5
      errors.add(:images, "You can upload up to 5 images")
    end
  end
end
