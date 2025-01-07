require 'metainspector'

class LinkPreviewService
  def self.fetch(url)
    page = MetaInspector.new(url, allow_redirections: :all)
    {
      title: page.title || "No title available",
      description: page.description || "No description available",
      image: page.images.best,
      url: page.url
    }
  rescue => e
    Rails.logger.error "Error fetching preview for #{url}: #{e.message}"
    nil
  end
end
