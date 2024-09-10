require 'rails_helper'

RSpec.describe "Notifiers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/notifiers/index"
      expect(response).to have_http_status(:success)
    end
  end
end
