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
end
