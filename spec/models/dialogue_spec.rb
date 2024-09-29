require 'rails_helper'

RSpec.describe Dialogue, type: :model do
  let(:sender) { create(:user) }
  let(:recipient) { create(:user) }
  let(:dialogue) { create(:dialogue, sender: sender, recipient: recipient) }

  describe 'associations' do
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:recipient).class_name('User') }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:dialogue) }
    it { is_expected.to validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  end

  describe 'scopes' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:dialogue) { create(:dialogue, sender: user1, recipient: user2) }

    it 'returns the dialogue between two users' do
      result = Dialogue.between(user1.id, user2.id)
      expect(result).to include(dialogue)
    end

    it 'returns the dialogue even if the sender and recipient are swapped' do
      result = Dialogue.between(user2.id, user1.id)
      expect(result).to include(dialogue)
    end

    it 'does not return dialogues for other users' do
      other_user = create(:user)
      result = Dialogue.between(user1.id, other_user.id)
      expect(result).to be_empty
    end
  end

  describe '#unread_messages_count_for' do
    it 'returns 0 when there are no messages' do
      expect(dialogue.unread_messages_count_for(recipient)).to eq(0)
    end

    it 'returns 0 when all messages are read' do
      create(:message, dialogue: dialogue, user: sender, read: true)
      create(:message, dialogue: dialogue, user: recipient, read: true)
      
      expect(dialogue.unread_messages_count_for(recipient)).to eq(0)
    end

    it 'counts only unread messages not sent by the given user' do
      create(:message, dialogue: dialogue, user: sender, read: false)  # Unread, sent by sender
      create(:message, dialogue: dialogue, user: sender, read: true)   # Read, sent by sender
      create(:message, dialogue: dialogue, user: recipient, read: false) # Unread, sent by recipient

      expect(dialogue.unread_messages_count_for(recipient)).to eq(1)
    end

    it 'does not count messages sent by the given user' do
      create(:message, dialogue: dialogue, user: recipient, read: false)  # Unread, sent by recipient
      create(:message, dialogue: dialogue, user: sender, read: false)    # Unread, sent by sender

      expect(dialogue.unread_messages_count_for(recipient)).to eq(1)
    end

    it 'returns correct count for multiple unread messages' do
      create(:message, dialogue: dialogue, user: sender, read: false)
      create(:message, dialogue: dialogue, user: sender, read: false)
      create(:message, dialogue: dialogue, user: recipient, read: false)

      expect(dialogue.unread_messages_count_for(recipient)).to eq(2)
    end
  end
end
