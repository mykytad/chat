require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:dialogue) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:dialogue_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  let(:user) { create(:user) }
  let(:dialogue) { create(:dialogue, sender: user, recipient: create(:user)) }
  let(:message) { create(:message, user: user, dialogue: dialogue) }

  it "is valid with valid attributes" do
    expect(message).to be_valid
  end

  it "is invalid without a body" do
    message.body = nil
    expect(message).to_not be_valid
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
end
