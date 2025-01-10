require 'rails_helper'

RSpec.describe LinkPreviewService, type: :service do
  describe '.fetch' do
    context 'when the URL is an image' do
      let(:image_url) { 'https://example.com/image.jpg' }

      it 'returns preview data with the image URL' do
        result = LinkPreviewService.fetch(image_url)

        expect(result).to include(
          image: image_url,
          url: image_url
        )
      end
    end

    context 'when the URL is a webpage' do
      let(:webpage_url) { 'https://example.com' }
      let(:meta_inspector_double) do
        double(
          'MetaInspector',
          title: 'Example Title',
          description: 'Example description',
          images: double('Images', best: 'https://example.com/image.png'),
          url: webpage_url
        )
      end

      before do
        allow(MetaInspector).to receive(:new).with(webpage_url, allow_redirections: :all)
                                             .and_return(meta_inspector_double)
      end

      it 'returns preview data from MetaInspector' do
        result = described_class.fetch(webpage_url)

        expect(result).to eq(
          title: 'Example Title',
          description: 'Example description',
          image: 'https://example.com/image.png',
          url: webpage_url
        )
      end
    end

    context 'when the URL is invalid' do
      let(:invalid_url) { 'invalid_url' }

      it 'returns nil and logs an error' do
        expect(Rails.logger).to receive(:error).with(/Error fetching preview for/)
        result = LinkPreviewService.fetch(invalid_url)

        expect(result).to be_nil
      end
    end

    context 'when the URL causes a MetaInspector error' do
      let(:error_url) { 'https://example.com' }

      before do
        allow(MetaInspector).to receive(:new).with(error_url, allow_redirections: :all)
                                             .and_raise(MetaInspector::TimeoutError, 'Timeout occurred')
      end

      it 'returns nil and logs an error' do
        expect(Rails.logger).to receive(:error).with(/Timeout occurred/)
        result = LinkPreviewService.fetch(error_url)

        expect(result).to be_nil
      end
    end
  end

  describe '.image_url?' do
    it 'returns true for URLs with image extensions' do
      %w[jpg jpeg png gif webp].each do |ext|
        expect(LinkPreviewService.image_url?("https://example.com/image.#{ext}")).to be true
      end
    end

    it 'returns false for URLs without image extensions' do
      expect(LinkPreviewService.image_url?('https://example.com')).to be false
    end

    it 'returns false for invalid URLs' do
      expect(LinkPreviewService.image_url?('not a url')).to be false
    end
  end
end
