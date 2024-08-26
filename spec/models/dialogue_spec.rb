require 'rails_helper'

RSpec.describe Dialogue, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:recipient).class_name('User') }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:dialogue) }  # Создаем объект для тестирования валидации уникальности
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
end
