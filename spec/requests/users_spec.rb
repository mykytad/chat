require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    let!(:user) { create(:user, name: "Test User") }
    let(:avatar_path) { Rails.root.join("public/images/#{Digest::SHA1.hexdigest(user.id.to_s)}.png") }

    context 'when the user exists' do
      it 'assigns the requested user to @user' do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it 'generates an avatar if it does not exist' do
        File.delete(avatar_path) if File.exist?(avatar_path) # Удаляем аватар, если он существует
        expect(File).not_to exist(avatar_path)

        get :show, params: { id: user.id }

        expect(File).to exist(avatar_path)
      end

      it 'does not generate an avatar if it already exists' do
        # Создаем аватар для теста
        img = Avatarly.generate_avatar(user.name, size: 40)
        File.open(avatar_path, 'wb') { |f| f.write(img) }

        expect(File).to exist(avatar_path)

        get :show, params: { id: user.id }

        # Проверяем, что не было создано новых файлов
        expect(File).to exist(avatar_path)
      end
    end

    context 'when the user does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :show, params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
