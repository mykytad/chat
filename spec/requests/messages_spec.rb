require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:user) { create(:user) }
  let!(:recipient) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:dialogue) { create(:dialogue, sender: user, recipient: recipient) }
  let!(:other_dialogue) { create(:dialogue, sender: other_user, recipient: recipient) }
  let!(:message) { create(:message, dialogue: dialogue, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response for a valid dialogue" do
      get dialogue_messages_path(dialogue)
      expect(response).to have_http_status(:success)
      expect(assigns(:messages)).to eq(dialogue.messages.order(:created_at))
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

    context "as a non-participant" do
      before { sign_in other_user }

      it "does not create a new message" do
        expect {
          post dialogue_messages_path(dialogue), params: { message: { body: "Unauthorized message" } }
        }.not_to change(Message, :count)

        expect(response).to redirect_to(dialogues_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when the user owns the message" do
      it "updates the message" do
        patch dialogue_message_path(dialogue, message), params: { message: { body: "Updated content" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        message.reload
        expect(message.body).to eq("Updated content")
      end
    end

    context "when the user does not own the message" do
      before { sign_in recipient }

      it "does not update the message" do
        patch dialogue_message_path(dialogue, message), params: { message: { body: "Invalid update" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        message.reload
        expect(message.body).not_to eq("Invalid update")
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

    it "does not delete the message for an invalid user" do
      sign_in other_user
      expect {
        delete dialogue_message_path(dialogue, message)
      }.not_to change(Message, :count)

      expect(response).to redirect_to(dialogues_path)
    end
  end

  describe "PATCH #read" do
    let!(:unread_message) { create(:message, dialogue: dialogue, user: recipient, read: false) }

    it "marks all messages as read for the current user" do
      patch read_dialogue_message_path(dialogue, unread_message)
      expect(response).to have_http_status(:ok)
      unread_message.reload
      expect(unread_message.read).to be true
    end
  end
end
