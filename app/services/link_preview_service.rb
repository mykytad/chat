require 'metainspector'

class LinkPreviewService
  IMAGE_EXTENSIONS = %w[jpg jpeg png gif webp].freeze

  def self.fetch(url)
    if image_url?(url)
      # If the link is to an image, return data with it
      {
        image: url,
        url: url
      }
    else
      # If the link is to a web page, use MetaInspector
      page = MetaInspector.new(url, allow_redirections: :all)
      {
        title: page.title,
        description: page.description,
        image: page.images.best,
        url: page.url
      }
    end
  rescue MetaInspector::TimeoutError, MetaInspector::RequestError => e
    Rails.logger.error "Error fetching preview for #{url}: #{e.message}"
    nil
  end

  def self.image_url?(url)
    uri = URI.parse(url)
    extension = File.extname(uri.path).delete('.').downcase
    IMAGE_EXTENSIONS.include?(extension)
  rescue URI::InvalidURIError
    false
  end
end
