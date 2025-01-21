require 'rails_helper'

RSpec.describe AvatarGenerator do
  describe '.generate' do
    let(:user) { instance_double("User", id: 1, name: "Test User") } # Mocking a User object using instance_double
    let(:avatar_hash) { Digest::SHA1.hexdigest(user.id.to_s) } # Expected avatar hash
    let(:file_path) { Rails.root.join("public", "images", "#{avatar_hash}.png") } # Path to the avatar file

    before do
      # Mocking Digest::SHA1.hexdigest to return a fixed hash
      allow(Digest::SHA1).to receive(:hexdigest).with(user.id.to_s).and_return(avatar_hash)
    end

    context 'when the avatar file does not exist' do
      before do
        # Indicating that the avatar file does not exist
        allow(File).to receive(:exist?).with(file_path).and_return(false)
        # Mocking avatar generation using Avatarly
        allow(Avatarly).to receive(:generate_avatar).with(user.name, size: 40).and_return("fake_avatar_data")
        # Mocking file writing
        allow(File).to receive(:open).and_yield(double('file', write: true))
      end

      it 'generates a new avatar file' do
        # Ensuring Avatarly.generate_avatar is called with correct arguments
        expect(Avatarly).to receive(:generate_avatar).with(user.name, size: 40)
        # Ensuring File.open is called to write the file
        expect(File).to receive(:open).with(file_path, 'wb')

        described_class.generate(user) # Calling the method under test
      end

      it 'returns the correct avatar hash' do
        # Ensuring the method returns the correct hash
        result = described_class.generate(user)
        expect(result).to eq(avatar_hash)
      end
    end

    context 'when the avatar file already exists' do
      before do
        # Indicating that the avatar file already exists
        allow(File).to receive(:exist?).with(file_path).and_return(true)
      end

      it 'does not generate a new avatar file' do
        # Ensuring Avatarly.generate_avatar is not called
        expect(Avatarly).not_to receive(:generate_avatar)
        # Ensuring File.open is not called
        expect(File).not_to receive(:open)

        described_class.generate(user) # Calling the method under test
      end

      it 'returns the correct avatar hash' do
        # Ensuring the method returns the correct hash
        result = described_class.generate(user)
        expect(result).to eq(avatar_hash)
      end
    end
  end
end
