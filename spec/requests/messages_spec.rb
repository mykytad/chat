require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:user) { create(:user) }
  let!(:recipient) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:dialogue) { create(:dialogue, sender: user, recipient: recipient) }
  let!(:other_dialogue) { create(:dialogue, sender: other_user, recipient: recipient) }
  let!(:message1) { create(:message, dialogue: dialogue, user: user, read: false) }
  let!(:message2) { create(:message, dialogue: dialogue, user: recipient, read: false) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when the user is a participant of the dialogue" do
      it "marks unread messages from the other user as read" do
        get dialogue_messages_path(dialogue)
        message2.reload
        expect(message2.read).to be true
      end

      it "does not mark messages sent by the current user as read" do
        get dialogue_messages_path(dialogue)
        message1.reload
        expect(message1.read).to be false
      end

      it "returns nil if replied_to_id does not exist" do
        get dialogue_messages_path(dialogue, params: { replied_to_id: 999 })
        expect(assigns(:replied_message)).to be_nil
      end

      it "sets the replied message when replied_to_id exists" do
        replied_message = create(:message, dialogue: dialogue, user: recipient)
        get dialogue_messages_path(dialogue, params: { replied_to_id: replied_message.id })
        expect(assigns(:replied_message)).to eq(replied_message.body)
      end
    end
    context "when replied_to_id is present" do
      it "returns nil if replied_to_id does not exist" do
        get dialogue_messages_path(dialogue, params: { replied_to_id: 999 })
        expect(assigns(:replied_message)).to be_nil
      end
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

      it "updates the last_message and updated_at fields of the dialogue" do
        post dialogue_messages_path(dialogue), params: { message: { body: "Hello!" } }

        dialogue.reload
        expect(dialogue.last_message).to eq("Hello!")
        expect(dialogue.updated_at).not_to eq(dialogue.created_at)
      end
    end

    context "with a message containing a URL" do
      before do
        allow(LinkPreviewService).to receive(:fetch).and_return(
          title: 'Example Title',
          description: 'Example Description',
          image: 'https://example.com/image.png',
          url: 'https://example.com'
        )
      end

      it "fetches the link preview and includes the data in the message" do
        post dialogue_messages_path(dialogue), params: { message: { body: "Check this out: https://example.com" } }

        message = Message.last
        expect(message.link_title).to eq('Example Title')
        expect(message.link_description).to eq('Example Description')
        expect(message.link_image).to eq('https://example.com/image.png')
        expect(message.link_url).to eq('https://example.com')
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
        patch dialogue_message_path(dialogue, message1), params: { message: { body: "Updated content" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        message1.reload
        expect(message1.body).to eq("Updated content")
      end
    end

    context "when the user does not own the message" do
      before { sign_in recipient }

      it "does not update the message" do
        patch dialogue_message_path(dialogue, message1), params: { message: { body: "Invalid update" } }
        expect(response).to redirect_to(dialogue_messages_path(dialogue))
        message1.reload
        expect(message1.body).not_to eq("Invalid update")
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
        delete dialogue_message_path(dialogue, message1)
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
