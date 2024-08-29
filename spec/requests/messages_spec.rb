require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:user) { create(:user) }
  let!(:recipient) { create(:user) }
  let!(:dialogue) { create(:dialogue, sender: user, recipient: recipient) }
  let!(:message) { create(:message, dialogue: dialogue, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get dialogue_messages_path(dialogue)
      expect(response).to have_http_status(:success)
      expect(assigns(:messages)).to eq(dialogue.messages)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new message and redirects" do
        expect {
          post dialogue_messages_path(dialogue), params: { message: { body: "Hello!" } }
        }.to change(Message, :count).by(1)

        expect(response).to redirect_to(dialogue_messages_path(dialogue))
      end
    end

    context "with invalid attributes" do
      it "does not create a new message and redirects" do
        expect {
          post dialogue_messages_path(dialogue), params: { message: { body: "" } }
        }.to_not change(Message, :count)

        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        follow_redirect!

        expect(flash[:alert]).to eq('Failed to send message.')
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the message and redirects" do
        patch dialogue_message_path(dialogue, message), params: { message: { body: "Updated message" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        message.reload
        expect(message.body).to eq("Updated message")
      end
    end

    context "with invalid attributes" do
      it "does not update the message and renders edit" do
        patch dialogue_message_path(dialogue, message), params: { message: { body: "" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        follow_redirect!
        expect(response.body).to include('Failed to update message.')
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the message and redirects" do
      message_to_delete = create(:message, dialogue: dialogue, user: user)

      expect {
        delete dialogue_message_path(dialogue, message_to_delete)
      }.to change(Message, :count).by(-1)

      expect(response).to redirect_to(dialogue_messages_path(dialogue))
    end
  end
end
