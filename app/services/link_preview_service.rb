require 'metainspector'

class LinkPreviewService
  IMAGE_EXTENSIONS = %w[jpg jpeg png gif webp].freeze

  def self.fetch(url)
    if image_url?(url)
      # Если ссылка на изображение, возвращаем данные с ним
      {
        image: url,
        url: url
      }
    else
      # Если ссылка на веб-страницу, используем MetaInspector
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
