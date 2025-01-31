require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:dialogue) }
  end

  let(:user) { create(:user) }
  let(:dialogue) { create(:dialogue, sender: user, recipient: create(:user)) }
  let(:message) { create(:message, user: user, dialogue: dialogue) }

  it "is invalid without text or an image" do
    message = Message.new(body: "", user: user, dialogue: dialogue)

    expect(message).to_not be_valid
    expect(message.errors[:base]).to include("The message must contain text or at least one image")
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dialogue_id) }
    it { is_expected.to validate_presence_of(:user_id) }

    it "is invalid without text or an image" do
      # Create a message without text and images
      message = Message.new(body: "", user: user, dialogue: dialogue)

      # Check that the message is invalid and an error appears with the desired message
      expect(message).to_not be_valid
      expect(message.errors[:base]).to include("The message must contain text or at least one image")
    end

    it "is valid with text" do
      # Create message with text
      message = Message.new(body: "Hello!", user: user, dialogue: dialogue)
      expect(message).to be_valid
    end

    it "is valid with an image and no text" do
      # Create message with image
      message = Message.new(
        images: [fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpg')],
        user: user,
        dialogue: dialogue
      )
      expect(message).to be_valid
    end

    it "is invalid with more than 5 images" do
      user = create(:user)
      dialogue = create(:dialogue, sender: user, recipient: create(:user))

      message = Message.new(
        images: [
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpg'),
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image2.jpg'), 'image/jpg'),
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image3.jpg'), 'image/jpg'),
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image4.jpg'), 'image/jpg'),
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image5.jpg'), 'image/jpg'),
          fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image6.jpg'), 'image/jpg')
        ],
        user: user,
        dialogue: dialogue
      )

      expect(message).to_not be_valid
      expect(message.errors[:images]).to include("You can upload up to 5 images")
    end
  end

  it "can reply to another message" do
    original_message = create(:message, user: user, dialogue: dialogue)
    reply_message = create(:message, user: user, dialogue: dialogue, replied_to_id: original_message.id)

    expect(reply_message.replied_to_id).to eq(original_message.id)
  end

  describe 'read/unread status' do
    it 'is marked as unread by default' do
      expect(message.read).to eq(false)
    end

    it 'can be marked as read' do
      message.update(read: true)
      expect(message.read).to eq(true)
    end
  end

  describe 'scopes' do
    let(:recipient) { create(:user) }
    let(:unread_message) { create(:message, dialogue: dialogue, user: recipient, read: false) }
    let(:read_message) { create(:message, dialogue: dialogue, user: recipient, read: true) }

    it 'returns unread messages for a specific user' do
      expect(Message.unread_by(user)).to include(unread_message)
      expect(Message.unread_by(user)).not_to include(read_message)
    end
  end

  describe 'callbacks' do
    let(:user) { create(:user) }
    let(:dialogue) { create(:dialogue, sender: user, recipient: create(:user)) }
    let!(:message) { create(:message, user: user, dialogue: dialogue) }

    context 'after_destroy_commit' do
      it 'broadcasts a remove message to Turbo Streams' do
        expect {
          message.destroy
        }.to have_broadcasted_to("dialogue_#{dialogue.id}_messages").from_channel("Turbo::StreamsChannel").with {
          include(action: 'remove', target: "message_#{message.id}")
        }
      end
    end
  end

  describe 'private methods' do
    let(:message_with_url) { build(:message, body: "Check out this link: https://example.com") }
    let(:message_with_html) { build(:message, body: "<h1>Hello</h1>") }

    describe '#escape_html' do
      it "escapes HTML tags in the message body" do
        message_with_html.send(:escape_html)
        expect(message_with_html.body).to eq("&lt;h1&gt;Hello&lt;/h1&gt;")
      end
    end

    describe '#fetch_link_preview' do
      context 'when the message body contains a valid URL' do
        before do
          allow(LinkPreviewService).to receive(:fetch).and_return(
            title: 'Example Title',
            description: 'Example Description',
            image: 'https://example.com/image.png',
            url: 'https://example.com'
          )
        end

        it "fetches the link preview and updates the message fields" do
          message_with_url.send(:fetch_link_preview)
          expect(message_with_url.link_title).to eq('Example Title')
          expect(message_with_url.link_description).to eq('Example Description')
          expect(message_with_url.link_image).to eq('https://example.com/image.png')
          expect(message_with_url.link_url).to eq('https://example.com')
        end
      end

      context 'when the message body does not contain a valid URL' do
        it "does not update the message fields" do
          message_with_html.send(:fetch_link_preview)
          expect(message_with_html.link_title).to be_nil
          expect(message_with_html.link_description).to be_nil
          expect(message_with_html.link_image).to be_nil
          expect(message_with_html.link_url).to be_nil
        end
      end
    end
  end
end
