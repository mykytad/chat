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
  rescue MetaInspector::TimeoutError, MetaInspector::RequestError => e
    Rails.logger.error "Error fetching preview for #{url}: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
    nil
  rescue StandardError => e
    Rails.logger.error "Unexpected error for #{url}: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
    nil
  end
end
