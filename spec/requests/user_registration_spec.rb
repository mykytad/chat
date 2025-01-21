require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  # Extend Devise test helpers to simulate user sign-in and other behaviors
  include Devise::Test::ControllerHelpers
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'Test User', phone: '123456789', email: 'test@example.com', password: 'password' } }
    let(:invalid_attributes) { { name: '', phone: '', email: '', password: '' } }

    context 'with valid attributes' do
      it 'creates a new user and sets a unique nickname' do
        # Simulate the POST request to the create action
        post :create, params: { user: valid_attributes }

        # Expect the user to be saved successfully
        expect(assigns(:user)).to be_persisted

        # Check if the nickname is correctly set
        nickname = assigns(:user).nickname
        expect(nickname).to match(/^@\w+\d{3}$/) # Nickname should start with '@' and end with a random 3-digit number
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        user = assigns(:user)
        expect(user).to be_a_new(User) # Check that the object is new and not saved
        expect(user.errors.any?).to be true # Let's make sure there are validation errors
      end
    end
  end

  describe 'before_action :set_avatar' do
    let(:user) { create(:user) } # Assuming a factory is defined for User

    before do
      # Simulate user sign-in
      sign_in user
      # Mock AvatarGenerator to prevent actual file creation
      allow(AvatarGenerator).to receive(:generate).with(user).and_return('mock_avatar_hash')
    end

    it 'generates an avatar for the current user when editing their profile' do
      # Simulate GET request to the edit action
      get :edit

      # Verify that the avatar was generated
      expect(assigns(:avatar)).to eq('mock_avatar_hash')
    end

    it 'generates an avatar for the current user when updating their profile' do
      # Simulate PUT request to the update action
      put :update, params: { user: { name: 'Updated Name' } }

      # Verify that the avatar was generated
      expect(assigns(:avatar)).to eq('mock_avatar_hash')
    end
  end

  describe 'protected methods' do
    it 'permits additional sign-up parameters' do
      # Mock the Devise parameter sanitizer
      sanitizer = double('Devise::ParameterSanitizer')
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)

      # Expect :sign_up keys to include :phone, :name, and :nickname
      expect(sanitizer).to receive(:permit).with(:sign_up, keys: [:phone, :name, :nickname])

      controller.send(:configure_sign_up_params) # Call the protected method directly
    end
  end
end
