require 'rails_helper'

RSpec.describe User, type: :model do
  # Create a valid user to use in the tests
  subject {
    described_class.new(
      phone: "1234567890",
      name: "John Doe",
      email: "john.doe@example.com",
      password: "password",
      nickname: "johndoe"
    )
  }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      subject.save
      another_user = described_class.new(
        phone: "0987654321",
        name: "Jane Doe",
        email: subject.email,
        password: "password",
        nickname: "janedoe"
      )
      expect(another_user).to_not be_valid
    end

    it 'is valid with a unique email' do
      subject.save
      another_user = described_class.new(
        phone: "0987654321",
        name: "Jane Doe",
        email: "jane.doe@example.com",
        password: "password",
        nickname: "janedoe"
      )
      expect(another_user).to be_valid
    end
  end

  describe 'Database' do
    it { should have_db_column(:phone).of_type(:string) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:nickname).of_type(:string) }
    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:reset_password_token).unique(true) }
  end

  describe 'Associations' do
    it { should have_many(:messages) }
    # it { should have_many(:dialogues) }
  end
end
