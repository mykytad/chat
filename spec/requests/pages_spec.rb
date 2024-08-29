require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #about' do
    it 'returns a successful response' do
      get :about
      expect(response).to have_http_status(:success) # или expect(response).to be_successful
    end

    it 'renders the about template' do
      get :about
      expect(response).to render_template(:about)
    end
  end

  describe 'GET #contacts' do
    it 'returns a successful response' do
      get :contacts
      expect(response).to have_http_status(:success) # или expect(response).to be_successful
    end

    it 'renders the contacts template' do
      get :contacts
      expect(response).to render_template(:contacts)
    end
  end
end
